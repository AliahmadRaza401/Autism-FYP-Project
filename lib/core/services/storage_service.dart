import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required String path,
    required File file,
    int maxRetries = 3,
    Function(double)? onProgress,
  }) async {
    int retryCount = 0;
    Exception? lastException;

    while (retryCount < maxRetries) {
      try {
       
        final compressedFile = await _compressImage(file);
        
       
        final ref = _storage.ref().child(path);
        
      
        final uploadTask = ref.putFile(
          compressedFile,
          SettableMetadata(contentType: _getContentType(file.path)),
        );

       
        if (onProgress != null) {
          uploadTask.snapshotEvents.listen((snapshot) {
            final progress = snapshot.bytesTransferred / snapshot.totalBytes;
            onProgress(progress);
          });
        }

       
        final snapshot = await uploadTask;
        
        if (snapshot.state == TaskState.success) {
          final downloadUrl = await snapshot.ref.getDownloadURL();
          
          if (compressedFile.path != file.path) {
            await compressedFile.delete();
          }
          
          return downloadUrl;
        } else {
          throw Exception('Upload failed with state: ${snapshot.state}');
        }
      } on FirebaseException catch (e) {
        lastException = e;
        
        if (_shouldNotRetry(e.code)) {
          rethrow;
        }
        
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      } catch (e) {
        lastException = e as Exception;
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      }
    }

    throw lastException ?? Exception('Upload failed after $maxRetries attempts');
  }

  Future<File> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) return file;

      int width = image.width;
      int height = image.height;
      const maxWidth = 1920;
      const maxHeight = 1080;

      if (width > maxWidth || height > maxHeight) {
        final ratio = width / height;
        if (ratio > 1) {
          width = maxWidth;
          height = (maxWidth / ratio).round();
        } else {
          height = maxHeight;
          width = (maxHeight * ratio).round();
        }
      }

    
      final resized = img.copyResize(image, width: width, height: height);
      final compressed = img.encodeJpg(resized, quality: 85);
      
    
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressed);
      
      return tempFile;
    } catch (e) {
      return file;
    }
  }


  String _getContentType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  /// Check if error should not be retried
  bool _shouldNotRetry(String? errorCode) {
    const noRetryErrors = [
      'unauthorized',
      'unauthenticated',
      'permission-denied',
      'invalid-argument',
    ];
    return errorCode != null && noRetryErrors.contains(errorCode);
  }


  Future<void> deleteFile({required String path}) async {
    try {
      await _storage.ref().child(path).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        rethrow;
      }
    }
  }

  /// Get download URL for existing file
  Future<String?> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return null;
      }
      rethrow;
    }
  }


  Future<bool> fileExists(String path) async {
    try {
      await _storage.ref().child(path).getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }
}

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  /// Upload file and return both url + path
  Future<Map<String, String>> uploadImage({
    required File file,
    required String folder,
    Function(double)? onProgress,
  }) async {
    try {
      // Generate safe unique path
      final fileName = "${_uuid.v4()}.jpg";
      final path = "$folder/$fileName";

      print("Uploading to: $path");

      final compressedFile = await _compressImage(file);
      final ref = _storage.ref().child(path);

      final uploadTask = ref.putFile(
        compressedFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((snapshot) {
          final progress =
              snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      final snapshot = await uploadTask;

      if (snapshot.state != TaskState.success) {
        throw Exception("Upload failed");
      }

      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Delete temp compressed file if different
      if (compressedFile.path != file.path) {
        await compressedFile.delete();
      }

      return {
        "url": downloadUrl,
        "path": path,
      };
    } on FirebaseException catch (e) {
      print("Firebase Error: ${e.code}");
      rethrow;
    } catch (e) {
      print("Upload Error: $e");
      rethrow;
    }
  }



  /// Compress image
  Future<File> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return file;

      const maxWidth = 1920;
      const maxHeight = 1080;

      int width = image.width;
      int height = image.height;

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

      final resized =
          img.copyResize(image, width: width, height: height);
      final compressed =
          img.encodeJpg(resized, quality: 85);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");

      await tempFile.writeAsBytes(compressed);

      return tempFile;
    } catch (_) {
      return file;
    }
  }

  /// Get download URL safely
  Future<String?> getDownloadUrl(String path) async {
    try {
      print("Getting URL for: $path");
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == "object-not-found") {
        print("File not found at $path");
        return null;
      }
      rethrow;
    }
  }

  /// Delete file safely
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } on FirebaseException catch (e) {
      if (e.code != "object-not-found") {
        rethrow;
      }
    }
  }

  /// Check file existence
  Future<bool> fileExists(String path) async {
    try {
      await _storage.ref().child(path).getMetadata();
      return true;
    } catch (_) {
      return false;
    }
  }
}

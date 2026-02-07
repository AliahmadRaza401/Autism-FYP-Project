import '../../core/services/firestore_service.dart';
import '../models/post_model.dart';

class CommunityRepository {
  final FirestoreService _firestoreService;

  CommunityRepository(this._firestoreService);

  Future<void> createPost(PostModel post) async {
    await _firestoreService.setData(
      path: 'posts/${post.id}',
      data: post.toMap(),
    );
  }

  Stream<List<PostModel>> getPosts() {
    return _firestoreService.collectionStream(
      path: 'posts',
      builder: (data, id) => PostModel.fromMap(data, id),
      sort: (a, b) => b.createdAt.compareTo(a.createdAt),
    );
  }

  Future<void> likePost(String postId, String userId) async {
    final post = await _firestoreService.getDocument(
      path: 'posts/$postId',
      builder: (data, id) => PostModel.fromMap(data, id),
    );
    
    final updatedLikes = List<String>.from(post.likes);
    if (updatedLikes.contains(userId)) {
      updatedLikes.remove(userId);
    } else {
      updatedLikes.add(userId);
    }

    await _firestoreService.updateData(
      path: 'posts/$postId',
      data: {'likes': updatedLikes},
    );
  }
}

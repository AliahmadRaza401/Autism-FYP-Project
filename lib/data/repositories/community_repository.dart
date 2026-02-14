import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/group_model.dart';
import '../models/group_post_model.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
  Future<void> createPost(PostModel post) async {
    await _firestore.collection('posts').doc(post.id).set(post.toMap());
  }

  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> likePost(String postId, String userId) async {
    await _firestore.collection('likes').add({
      'postId': postId,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    
    await _firestore.collection('posts').doc(postId).update({
      'likesCount': FieldValue.increment(1),
    });
  }

  Stream<List<GroupModel>> getGroups() {
    return _firestore
        .collection('groups')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> joinGroup(String groupId, String userId) async {
    final batch = _firestore.batch();
    final memberRef = _firestore.collection('groupMembers').doc('${groupId}_$userId');
    batch.set(memberRef, {
      'groupId': groupId,
      'userId': userId,
      'joinedAt': FieldValue.serverTimestamp(),
    });

    batch.update(_firestore.collection('groups').doc(groupId), {
      'totalMembers': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Future<void> createGroupPost(String groupId, GroupPostModel post) async {
    await _firestore.collection('groupPosts').add(post.toMap());
  }

  Stream<List<GroupPostModel>> getGroupPosts(String groupId) {
    return _firestore
        .collection('groupPosts')
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupPostModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}

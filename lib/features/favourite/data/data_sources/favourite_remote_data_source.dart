import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezda_task/features/favourite/data/models/favourite_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<List<FavoriteModel>> getUserFavorites(String userId);
  Future<void> addToFavorites(String userId, int productId);
  Future<void> removeFromFavorites(String userId, int productId);
  Future<bool> isFavorite(String userId, int productId);
  Stream<List<FavoriteModel>> watchUserFavorites(String userId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'favorites';

  FavoriteRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<List<FavoriteModel>> getUserFavorites(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FavoriteModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user favorites: $e');
    }
  }

  @override
  Future<void> addToFavorites(String userId, int productId) async {
    try {
      // Check if already exists
      final existing = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();

      if (existing.docs.isEmpty) {
        await _firestore.collection(_collection).add({
          'userId': userId,
          'productId': productId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  @override
  Future<void> removeFromFavorites(String userId, int productId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();

      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(String userId, int productId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

  @override
  Stream<List<FavoriteModel>> watchUserFavorites(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavoriteModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }
}

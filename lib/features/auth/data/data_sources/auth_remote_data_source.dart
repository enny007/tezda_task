import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezda_task/core/exceptions/auth_exception.dart';
import 'package:tezda_task/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? photoUrl,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Login failed');
      }

      return await _getUserData(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Registration failed');
      }
      
      // Update display name
      await credential.user!.updateDisplayName(name);

      // Create user model
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );

      // Save user data to Firestore first
      await _saveUserData(user);
      
      // Return the user model directly
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? photoUrl,
  }) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null || currentUser.uid != userId) {
        throw const AuthException('User not authenticated');
      }

      if (name != null) {
        await currentUser.updateDisplayName(name);
      }
      if (photoUrl != null) {
        await currentUser.updatePhotoURL(photoUrl);
      }

      final currentUserData = await _getUserData(userId);
      final updatedUser = UserModel(
        id: currentUserData.id,
        email: currentUserData.email,
        name: name ?? currentUserData.name,
        photoUrl: photoUrl ?? currentUserData.photoUrl,
        createdAt: currentUserData.createdAt,
      );

      await _saveUserData(updatedUser);
      return updatedUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;
      return await _getUserData(user.uid);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      
      // Try multiple times to get user data with increasing delays
      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          return await _getUserData(user.uid);
        } catch (e) {
          if (e is AuthException && e.message.contains('User data not found')) {
            // Wait before retrying, with increasing delay
            await Future.delayed(Duration(milliseconds: 200 * (attempt + 1)));
            continue;
          } else {
            // For other errors, break and return null
            break;
          }
        }
      }
      
      // If all attempts failed, return null
      // Don't create fallback user data here as it might have incorrect info
      return null;
    });
  }

  Future<UserModel> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) throw const AuthException('User data not found');

      final data = doc.data()!;
      return UserModel.fromJson({
        'id': uid,
        ...data,
        'createdAt':
            (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
      });
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Failed to retrieve user data: ${e.toString()}');
    }
  }

  Future<void> _saveUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'email': user.email,
        'name': user.name,
        'photoUrl': user.photoUrl,
        'createdAt':
            user.createdAt != null ? Timestamp.fromDate(user.createdAt!) : null,
      });
    } catch (e) {
      throw AuthException('Failed to save user data: ${e.toString()}');
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-credential':
        return 'Invalid email or password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

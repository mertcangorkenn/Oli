// ignore_for_file: void_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:listing/app/domain/handler/api_result.dart';
import 'package:listing/app/domain/interface/auth.dart';
import 'package:listing/infrastructure/models/data/user_data_model.dart';

class AuthRepository implements AuthRepositoryFacade {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();

      return ApiResult.success(
        data: {
          'jwt': await user.getIdToken(),
          'user': UserModel.fromJson(userDoc.data() as Map<String, dynamic>),
        },
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> loginWithGoogle({
    required String email,
    required String displayName,
    required String id,
    required String avatar,
  }) async {
    try {
      User user = _firebaseAuth.currentUser!;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        UserModel newUser =
            UserModel(id: user.uid, email: email, username: displayName);
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());
        return ApiResult.success(
          data: {
            'jwt': await user.getIdToken(),
            'user': newUser,
          },
        );
      } else {
        return ApiResult.success(
          data: {
            'jwt': await user.getIdToken(),
            'user': UserModel.fromJson(userDoc.data() as Map<String, dynamic>),
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<void>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      UserModel newUser =
          UserModel(id: user.uid, email: email, username: username);

      await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

      return const ApiResult.success(data: 'signUp');
    } catch (e) {
      return ApiResult.failure(error: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<ApiResult<void>> signUpWithData({
    required UserModel user,
  }) async {
    try {
      return const ApiResult.success(data: 'signUpWithData');
    } catch (e) {
      debugPrint('==> signUpWithData failure: $e');
      return ApiResult.failure(
        error: "An unexpected error occurred",
        statusCode: _getFirebaseErrorStatusCode(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteAccount({
    required UserModel user,
  }) async {
    try {
      await _firebaseAuth.currentUser!.delete();
      await _firestore.collection('users').doc(user.id).delete();
      return const ApiResult.success(data: 'deleteAccount');
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<void>> forgotPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const ApiResult.success(data: 'sendPasswordResetEmail');
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  int _getFirebaseErrorStatusCode(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 400;
        case 'user-disabled':
          return 403;
        case 'user-not-found':
          return 404;
        case 'wrong-password':
          return 401;
        default:
          return 500;
      }
    }
    return 500;
  }
}

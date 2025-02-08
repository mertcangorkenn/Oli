// ignore_for_file: void_checks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listing/app/domain/handler/api_result.dart';
import 'package:listing/app/domain/interface/user.dart';
import 'package:listing/infrastructure/service/local_storage.dart';

class UserRepository implements UserRepositoryFacade {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ApiResult<Map<String, dynamic>>> getProfileDetails() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          final data = {
            'username': userData['username'],
            'email': userData['email'],
            'avatar': userData['avatar'],
            'id': userData['id'],
            'location': userData['location'],
            'phonenumber': userData['phonenumber'],
            'created': userData['created'],
            'fullname': userData['fullname'],
            'birthday': userData['birthday'],
            // 'gender': userData['gender'],
            'bio': userData['bio'],
            'holidaymode': userData['holidaymode'],
          };
          return ApiResult.success(data: data);
        } else {
          return const ApiResult.failure(
            error: 'User data not found',
            statusCode: 404,
          );
        }
      } else {
        return const ApiResult.failure(
          error: 'User not authenticated',
          statusCode: 401,
        );
      }
    } catch (e) {
      return ApiResult.failure(
        error: 'Error fetching user data: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ApiResult<void>> updateAvatar({String? avatar}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const ApiResult.failure(error: 'User not authenticated');
    }

    try {
      await firebaseFirestore.collection('users').doc(user.uid).update({
        if (avatar != null) 'avatar': avatar,
      });
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: 'Error updating profile: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ApiResult<void>> updateProfile(
      {String? gender, DateTime? birthday}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const ApiResult.failure(error: 'User not authenticated');
    }

    try {
      await firebaseFirestore.collection('users').doc(user.uid).update({
        if (gender != null) 'gender': gender,
        if (birthday != null) 'birthday': Timestamp.fromDate(birthday),
      });
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: 'Error updating profile: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ApiResult<void>> holidayMode({bool? holidayMode}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const ApiResult.failure(error: 'User not authenticated');
    }

    try {
      await firebaseFirestore.collection('users').doc(user.uid).update({
        if (holidayMode != null) 'holidaymode': holidayMode,
      });
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: 'holidaymode: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ApiResult<void>> logoutAccount({required String fcm}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
      LocalStorage.logout();
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
          error: "An unexpected error occurred",
          statusCode: _getFirebaseErrorStatusCode(e));
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

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listing/app/domain/interface/user.dart';
import 'package:listing/app/profile/profile_state.dart';
import 'package:listing/infrastructure/service/local_storage.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserRepositoryFacade _userRepository;
  ProfileNotifier(this._userRepository) : super(const ProfileState());

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> get userStream {
    final user = firebaseAuth.currentUser;
    if (user == null) return const Stream.empty();
    return firebaseFirestore.collection('users').doc(user.uid).snapshots();
  }

  Future<void> getProfileDetails() async {
    state = state.copyWith(isLoading: true);

    userStream.listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        final Timestamp? createdTimestamp = data['created'] as Timestamp?;
        final Timestamp? birthdayTimestamp = data['birthday'] as Timestamp?;

        final DateTime? createdDate = createdTimestamp?.toDate();
        final DateTime? birthdayDate = birthdayTimestamp?.toDate();

        final DateFormat formatter = DateFormat('dd MMM yyyy');

        final String formattedDate =
            createdDate != null ? formatter.format(createdDate) : '';
        final String formatBirthday =
            birthdayDate != null ? formatter.format(birthdayDate) : '';

        state = state.copyWith(
          isLoading: false,
          fullname: data['fullname'] as String? ?? '',
          username: data['username'] as String? ?? '',
          email: data['email'] as String? ?? '',
          avatar: data['avatar'] as String?,
          id: data['id'] as String? ?? '',
          location: data['location'] as String? ?? '',
          phonenumber: data['phonenumber'] as String? ?? '',
          bio: data['bio'] as String? ?? '',
          holidaymode: data['holidaymode'],
          created: createdTimestamp,
          formattedCreated: formattedDate,
          birthday: birthdayTimestamp,
          formattedBirthday: formatBirthday,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    }, onError: (error) {
      state = state.copyWith(isLoading: false);
      if (kDebugMode) {
        print('Error fetching user data: $error');
      }
    });
  }

  Future<void> uploadProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final File file = File(image.path);
    final storageRef = firebaseStorage
        .ref()
        .child('profile_pictures/${file.uri.pathSegments.last}');
    final uploadTask = storageRef.putFile(file);

    try {
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await _userRepository.updateAvatar(avatar: downloadUrl);
      state = state.copyWith(avatar: downloadUrl);
    } catch (e) {
      debugPrint('Error uploading profile picture: $e');
    }
  }

  Future<void> updateAvatar({String? avatar}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    await firebaseFirestore.collection('users').doc(user.uid).update({
      if (avatar != null) 'avatar': avatar,
    });
  }

  Future<void> updateProfile({String? gender, DateTime? birthday}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    await firebaseFirestore.collection('users').doc(user.uid).update({
      if (gender != null) 'gender': gender,
      if (birthday != null) 'birthday': Timestamp.fromDate(birthday),
    });
  }

  Future<void> holidayMode({bool? holidayMode}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    await firebaseFirestore.collection('users').doc(user.uid).update({
      if (holidayMode != null) 'holidaymode': holidayMode,
    });
  }

  Future<void> logoutAccount(BuildContext context) async {
    final result = await _userRepository.logoutAccount(fcm: '');
    result.when(
      success: (_) {
        final auth = FirebaseAuth.instance;
        auth.signOut();
        LocalStorage.deleteToken();
        context.replaceRoute(const LandingRoute());
      },
      failure: (error, statusCode) {
        debugPrint('Logout failure: $error');
      },
    );
  }

  Future<Map<String, dynamic>?> getUsersById(String userId) async {
    try {
      final doc = await firebaseFirestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<void> fetchUserItems(String userId) async {
    try {
      final userItemsSnapshot = await firebaseFirestore
          .collection('items')
          .where('userid', isEqualTo: userId)
          .get();

      final userItems =
          userItemsSnapshot.docs.map((doc) => doc.data()).toList();

      if (kDebugMode) {
        print(userItems);
      }
      state = state.copyWith(userItems: userItems);
    } catch (e) {
      debugPrint('Error fetching user items: $e');
    }
  }

  Future<void> addFavorite(String itemId) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(itemId)
          .set({});
      state = state.copyWith(favorites: [...state.favorites, itemId]);
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> removeFavorite(String itemId) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(itemId)
          .delete();
      state = state.copyWith(
        favorites: state.favorites.where((id) => id != itemId).toList(),
      );
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  Future<bool> isFavorite(String itemId) async {
    final user = firebaseAuth.currentUser;
    if (user == null) return false;

    try {
      final doc = await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(itemId)
          .get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

  Stream<List<String>> favoritesStream() {
    final user = firebaseAuth.currentUser;
    if (user == null) return const Stream.empty();

    return firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}

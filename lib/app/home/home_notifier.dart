import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/home/home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> get itemsStream {
    return firebaseFirestore.collection('items').snapshots();
  }

  Future<void> fetchUserProfile(String userId) async {
    try {
      final docSnapshot =
          await firebaseFirestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        state = state.copyWith(
          userProfile: userData,
          userid: userId,
          fullname: userData?['fullname'] ?? '',
          email: userData?['email'] ?? '',
          avatar: userData?['avatar'] ?? '',
          location: userData?['location'] ?? '',
          phonenumber: userData?['phonenumber'] ?? '',
          bio: userData?['bio'] ?? '',
          gender: userData?['gender'] ?? '',
          username: userData?['username'] ?? '',
          formattedCreated: userData?['formattedCreated'] ?? '',
          formattedBirthday: userData?['formattedBirthday'] ?? '',
          holidaymode: userData?['holidaymode'] ?? false,
          favorites: List<String>.from(userData?['favorites'] ?? []),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
    }
  }

  Future<Map<String, dynamic>?> fetchUser(String userId) async {
    try {
      final docSnapshot =
          await firebaseFirestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
    }
    return null;
  }

  Future<void> fetchListing() async {
    state = state.copyWith(isLoading: true);
    itemsStream.listen((snapshot) async {
      final items = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final userId = data['userid'] as String;

        final userProfile = await fetchUser(userId);
        final username = userProfile?['username'] as String? ?? 'Unknown';
        final avatar = userProfile?['avatar'] as String? ?? '';

        return {
          'id': data['id'],
          'title': data['title'],
          'description': data['description'],
          'category': data['category'],
          'brand': data['brand'],
          'childcategory': data['childcategory'],
          'color': data['color'],
          'condition': data['condition'],
          'createdAt': data['createdAt'],
          'material': data['material'],
          'size': data['size'],
          'subcategory': data['subcategory'],
          'userid': userId,
          'username': username,
          'avatar': avatar,
          'images': List<String>.from(data['images'] ?? []),
          'price': (data['price'] as num).toDouble(),
        };
      }).toList());

      if (kDebugMode) {
        print('Fetched items: $items');
      }
      state = state.copyWith(
        items: items,
        isLoading: false,
      );
    }).onError((error) {
      state = state.copyWith(
        errorMessage: 'Error fetching listings: $error',
        isLoading: false,
      );
    });
  }

  Future<void> fetchItemDetails(String itemId) async {
    state = state.copyWith(isLoading: true);
    try {
      final docSnapshot =
          await firebaseFirestore.collection('items').doc(itemId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final createdAt = (data['createdAt'] as Timestamp).toDate();
        final formattedDate = DateFormat('dd MMM yyyy').format(createdAt);

        state = state.copyWith(
          id: data['id'] as String?,
          userid: data['userid'] as String?,
          title: data['title'] as String?,
          describe: data['description'] as String?,
          categoryId: data['categoryId'] as String?,
          category: data['category'] as String?,
          subcategoryId: data['subcategoryId'] as String?,
          subcategory: data['subcategory'] as String?,
          childcategory: data['childcategory'] as String?,
          brandId: data['brandId'] as String?,
          brand: data['brand'] as String?,
          colorId: data['colorId'] as String?,
          color: data['color'] as String?,
          sizeId: data['sizeId'] as String?,
          size: data['size'] as String?,
          conditionId: data['conditionId'] as String?,
          condition: data['condition'] as String?,
          materialId: data['materialId'] as String?,
          material: data['material'] as String?,
          price: data['price'] as int?,
          imagePaths: List<String>.from(data['images'] ?? []),
          createdAt: formattedDate,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          errorMessage: 'Item not found',
          isLoading: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching item details: $e');
      }
      state = state.copyWith(
        errorMessage: 'Error fetching item details: $e',
        isLoading: false,
      );
    }
  }
}

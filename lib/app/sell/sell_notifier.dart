import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listing/app/sell/sell_state.dart';
import 'package:listing/infrastructure/service/app_validators.dart';

class SellNotifier extends StateNotifier<SellState> {
  SellNotifier() : super(const SellState());

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDescription(String description) {
    state = state.copyWith(describe: description);
  }

  void setCategory(String category, String categoryId) {
    state = state.copyWith(category: category, categoryId: categoryId);
  }

  void setSubCategory(String subcategory, String subcategoryId) {
    state =
        state.copyWith(subcategory: subcategory, subcategoryId: subcategoryId);
  }

  void setChildCategory(String childcategory) {
    state = state.copyWith(childcategory: childcategory);
  }

  void setBrand(String brand, String brandId) {
    state = state.copyWith(brand: brand, brandId: brandId);
  }

  void setSize(String size, String sizeId) {
    state = state.copyWith(size: size, sizeId: sizeId);
  }

  void setColor(String color, String colorId) {
    state = state.copyWith(color: color, colorId: colorId);
  }

  void setCondition(String condition, String conditionId) {
    state = state.copyWith(condition: condition, conditionId: conditionId);
  }

  void setMaterial(String material, String materialId) {
    state = state.copyWith(material: material, materialId: materialId);
  }

  void setPrice(int price) {
    state = state.copyWith(price: price);
  }

  bool checkPrice(String price) {
    return AppValidators.validatePrice(price);
  }

  void clearCategories() {
    state = state.copyWith(subcategory: null, category: null);
  }

  void clearAll() {
    state = state.copyWith(
        imagePaths: [],
        title: null,
        describe: null,
        category: null,
        categoryId: null,
        subcategory: null,
        subcategoryId: null,
        brand: null,
        brandId: null,
        size: null,
        sizeId: null,
        color: null,
        colorId: null,
        condition: null,
        conditionId: null,
        material: null,
        materialId: null,
        price: null);
  }

  Future<void> selectImage() async {
    if (state.imagePaths.length >= 20) {
      return;
    }
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    final newPaths = pickedFiles.map((file) => file.path).toList();
    state = state.copyWith(
      imagePaths: [
        ...state.imagePaths,
        ...newPaths.take(20 - state.imagePaths.length)
      ],
    );
  }

  void deleteImage(int index) {
    final updatedPaths = List<String>.from(state.imagePaths)..removeAt(index);
    state = state.copyWith(imagePaths: updatedPaths);
  }

  Future<List<Map<String, String>>> fetchCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      final categories = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': data['id'] as String,
          'name': data['name'] as String,
        };
      }).toList();
      return categories;
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<List<Map<String, String>>> fetchSubCategories(
      String categoryId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('subcategories')
          .get();
      final subcategories = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': data['id'] as String,
          'name': data['name'] as String,
          'parentCategoryId': data['parentCategoryId'] as String,
        };
      }).toList();
      return subcategories;
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

  Future<List<Map<String, String>>> fetchBrand() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('brand').get();
      final brand = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': data['id'] as String,
          'name': data['name'] as String,
        };
      }).toList();
      return brand;
    } catch (e) {
      throw Exception('Error fetching brand: $e');
    }
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<void> uploadProduct() async {
    if (!validateForm()) {
      throw Exception('Form validation failed');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('userNotLoggedInError'.tr());
    }

    final itemDocRef = FirebaseFirestore.instance.collection('items').doc();

    final itemId = itemDocRef.id;
    setLoading(true);
    try {
      List<String> imageUrls = [];
      final storageRef =
          FirebaseStorage.instance.ref().child('item_images/$itemId');
      for (int i = 0; i < state.imagePaths.length; i++) {
        final imagePath = state.imagePaths[i];
        final fileName = '$itemId-${i + 1}.png';
        final imageRef = storageRef.child(fileName);
        final uploadTask = imageRef.putFile(File(imagePath));
        final snapshot = await uploadTask.whenComplete(() => {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      final itemData = {
        'userid': user.uid,
        'username': user.displayName,
        'id': itemId,
        'images': imageUrls,
        'title': state.title,
        'description': state.describe,
        'category': state.category,
        'subcategory': state.subcategory,
        'childcategory': state.childcategory,
        'brand': state.brand,
        'size': state.size,
        'color': state.color,
        'condition': state.condition,
        'material': state.material,
        'price': state.price,
        'createdAt': DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection('items')
          .doc(itemId)
          .set(itemData);
    } catch (e) {
      throw Exception('Error uploading product: $e');
    } finally {
      setLoading(false);
    }
  }

  bool validateForm() {
    return state.imagePaths.isNotEmpty &&
        state.title != null &&
        state.describe != null &&
        state.category != null &&
        state.color != null &&
        state.size != null &&
        state.material != null &&
        state.brand != null &&
        state.condition != null &&
        state.price != null;
  }
}

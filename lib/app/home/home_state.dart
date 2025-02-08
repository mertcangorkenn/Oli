import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(true) bool isLoading,
    @Default([]) List<Map<String, dynamic>> items,
    @Default(null) Map<String, dynamic>? itemDetails,
    @Default('') String errorMessage,
    @Default(null) String? id,
    @Default(null) String? username,
    @Default(null) String? phoneNumber,
    @Default(null) String? title,
    @Default(null) String? describe,
    @Default(null) String? categoryId,
    @Default(null) String? category,
    @Default(null) String? subcategoryId,
    @Default(null) String? subcategory,
    @Default(null) String? childcategory,
    @Default(null) String? brandId,
    @Default(null) String? brand,
    @Default(null) String? colorId,
    @Default(null) String? color,
    @Default(null) String? sizeId,
    @Default(null) String? size,
    @Default(null) String? conditionId,
    @Default(null) String? condition,
    @Default(null) String? materialId,
    @Default(null) String? material,
    @Default(null) int? price,
    @Default(null) String? createdAt,
    @Default(null) String? userid,
    @Default('') String? fullname,
    @Default('') String email,
    @Default('') String? avatar,
    @Default('') String location,
    @Default('') String? phonenumber,
    @Default('') String? bio,
    @Default('') String? gender,
    @Default('') String? formattedCreated,
    @Default('') String? formattedBirthday,
    @Default(false) bool? holidaymode,
    @Default([]) List<String> favorites,
    @Default([]) List<String> imagePaths,
    @Default(null) Map<String, dynamic>? userProfile,
  }) = _HomeState;

  const HomeState._();
}

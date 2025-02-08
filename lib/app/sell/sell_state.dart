import 'package:freezed_annotation/freezed_annotation.dart';

part 'sell_state.freezed.dart';

@freezed
class SellState with _$SellState {
  const factory SellState({
    @Default(false) bool isLoading,
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
    @Default([]) List<String> imagePaths,
    @Default(false) bool isPriceInvalid,
  }) = _SellState;

  const SellState._();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(true) bool isLoading,
    @Default('') String? fullname,
    @Default('') String username,
    @Default('') String email,
    @Default('') String? avatar,
    @Default('') String id,
    @Default('') String location,
    @Default('') String? phonenumber,
    @Default('') String? bio,
    @Default('') String? gender,
    @Default('') String? formattedCreated,
    @Default('') String? formattedBirthday,
    @Default(false) bool? holidaymode,
    @Default([]) List<String> favorites,
    @Default([]) List<Map<String, dynamic>> userItems,
    Timestamp? created,
    Timestamp? birthday,
  }) = _ProfileState;

  const ProfileState._();
}

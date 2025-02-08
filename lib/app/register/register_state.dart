import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(false) bool showPassword,
    @Default(false) bool isEmailInvalid,
    @Default(false) bool isPasswordInvalid,
    @Default(false) bool isUsernameInvalid,
    @Default(false) bool isFullnameInvalid,
    @Default('') String fullname,
    @Default('') String email,
    @Default('') String username,
    @Default('') String password,
    @Default('') String location,
  }) = _RegisterState;

  const RegisterState._();
}

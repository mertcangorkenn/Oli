import 'package:listing/app/domain/handler/api_result.dart';

abstract class UserRepositoryFacade {
  Future<ApiResult<Map<String, dynamic>>> getProfileDetails();
  Future<ApiResult<void>> updateAvatar({String? avatar});
  Future<ApiResult<void>> updateProfile({String? gender, DateTime? birthday});
  Future<ApiResult<void>> holidayMode({bool? holidayMode});
  Future<ApiResult<void>> logoutAccount({required String fcm});
}

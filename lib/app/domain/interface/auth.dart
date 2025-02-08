import 'package:listing/app/domain/handler/api_result.dart';
import 'package:listing/infrastructure/models/data/user_data_model.dart';

abstract class AuthRepositoryFacade {
  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<Map<String, dynamic>>> loginWithGoogle({
    required String email,
    required String displayName,
    required String id,
    required String avatar,
  });

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<void> signUpWithData({
    required UserModel user,
  });

  Future<void> deleteAccount({
    required UserModel user,
  });

  Future<void> forgotPassword({
    required String email,
  });
}

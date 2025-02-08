import 'package:get_it/get_it.dart';
import 'package:listing/app/domain/interface/auth.dart';
import 'package:listing/app/domain/interface/user.dart';
import 'package:listing/infrastructure/repository/auth_repository.dart';
import 'package:listing/infrastructure/repository/user_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerSingleton<AuthRepositoryFacade>(AuthRepository());
  getIt.registerSingleton<UserRepositoryFacade>(UserRepository());
}

final authRepository = getIt.get<AuthRepositoryFacade>();
final userRepository = getIt.get<UserRepositoryFacade>();

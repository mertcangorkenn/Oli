import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/splash/splash_state.dart';
import 'package:listing/infrastructure/service/app_connectivity.dart';
import 'package:listing/infrastructure/service/local_storage.dart';

class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier() : super(const SplashState());

  Future<void> getToken(
    BuildContext context, {
    VoidCallback? goMain,
    VoidCallback? goOnboarding,
    VoidCallback? goLogin,
    VoidCallback? goNoInternet,
  }) async {
    final connect = await AppConnectivity.connectivity();

    if (connect) {
      if (LocalStorage.getToken().isEmpty) {
        goLogin?.call();
      } else {
        goMain?.call();
      }
    } else {
      goNoInternet?.call();
    }
  }
}

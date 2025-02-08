import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/splash/splash_provider.dart';
import 'package:listing/infrastructure/service/app_assets.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await Future.delayed(const Duration(seconds: 2));
      ref.read(splashProvider.notifier).getToken(
        // ignore: use_build_context_synchronously
        context,
        goMain: () {
          if (kDebugMode) {
            print('goMain');
          }
          FlutterNativeSplash.remove();
          context.replaceRoute(const MainRoute());
        },
        goLogin: () {
          if (kDebugMode) {
            print('goLogin');
          }
          FlutterNativeSplash.remove();
          context.replaceRoute(const LandingRoute());
        },
        goNoInternet: () {
          if (kDebugMode) {
            print('goNoInternet');
          }
          FlutterNativeSplash.remove();
          context.replaceRoute(const NoConnectionRoute());
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        AppAssets.splash,
        fit: BoxFit.fill,
      ),
    );
  }
}

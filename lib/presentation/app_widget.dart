import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'routes/app_router.dart';

class AppWidget extends ConsumerWidget {
  AppWidget({super.key});

  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: Future.wait([FlutterDisplayMode.setHighRefreshRate()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          return ScreenUtilInit(
            useInheritedMediaQuery: false,
            designSize: const Size(375, 812),
            builder: (context, child) {
              return RefreshConfiguration(
                footerBuilder: () => const ClassicFooter(
                  idleIcon: SizedBox(),
                  idleText: "",
                ),
                headerBuilder: () => const WaterDropMaterialHeader(
                  backgroundColor: Style.white,
                  color: Style.black,
                ),
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  locale: context.locale,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  routerDelegate: appRouter.delegate(),
                  routeInformationParser: appRouter.defaultRouteParser(),
                  theme: ThemeData(
                    brightness: Brightness.light,
                    scaffoldBackgroundColor: Style.white,
                    appBarTheme: const AppBarTheme(
                        backgroundColor: Style.white,
                        surfaceTintColor: Style.white),
                    cupertinoOverrideTheme: MaterialBasedCupertinoThemeData(
                        materialTheme: ThemeData(
                      primaryColor: Style.mainColor,
                    )),
                    bottomNavigationBarTheme:
                        const BottomNavigationBarThemeData(
                            backgroundColor: Style.white),
                    bottomAppBarTheme:
                        const BottomAppBarTheme(color: Style.white),
                    dialogBackgroundColor: Style.white,
                    sliderTheme: SliderThemeData(
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}

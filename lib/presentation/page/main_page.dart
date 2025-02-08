import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        SearchRoute(),
        SellRoute(),
        InboxRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (value) {
              tabsRouter.setActiveIndex(value);
            },
            selectedItemColor: Style.mainColor,
            unselectedItemColor: Style.hintColor,
            unselectedFontSize: 12,
            selectedLabelStyle: GoogleFonts.lato(),
            unselectedLabelStyle: GoogleFonts.lato(),
            selectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Remix.home_2_line), label: 'home'.tr()),
              BottomNavigationBarItem(
                  icon: const Icon(Remix.search_line), label: 'search'.tr()),
              BottomNavigationBarItem(
                  icon: const Icon(Remix.add_circle_line), label: 'sell'.tr()),
              BottomNavigationBarItem(
                  icon: const Icon(Remix.mail_line), label: 'inbox'.tr()),
              BottomNavigationBarItem(
                icon: const Icon(Remix.user_line),
                label: 'profile'.tr(),
              ),
            ],
          ),
        );
      },
    );
  }
}

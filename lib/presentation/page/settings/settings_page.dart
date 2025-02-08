import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/infrastructure/service/app_constants.dart';
import 'package:listing/infrastructure/service/app_helpers.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/components/language_change_page.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.read(profileProvider.notifier);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: CustomAppBar(
        label: 'settings'.tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomMenuItem(
              label: 'profiledetails'.tr(),
              onTap: () {
                context.pushRoute(const ProfileDetailsRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            CustomMenuItem(
              label: 'accountsettings'.tr(),
              onTap: () {
                context.pushRoute(const AccountSettingsRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            // CustomMenuItem(
            //   label: 'security'.tr(),
            //   onTap: () {},
            //   showBorders: const {
            //     'top': false,
            //     'bottom': true,
            //   },
            // ),
            // 10.verticalSpace,
            CustomMenuItem(
              label: 'notification'.tr(),
              onTap: () {
                context.pushRoute(const NotificationSettingsRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            10.verticalSpace,
            Container(
              decoration: BoxDecoration(
                  color: Style.white,
                  border: Border.all(
                      width: 1, color: Style.black.withOpacity(0.1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  10.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'yourappslanguage'.tr(),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                          fontSize: 14, color: Style.hintColor),
                    ),
                  ),
                  CustomMenuItem(
                    label: 'language'.tr(),
                    onTap: () {
                      AppHelpers.showCustomModalBottomSheet(
                          context: context,
                          paddingTop: size.height * 0.6,
                          modal: const LanguageChangePage());
                    },
                    // ignore: avoid_unnecessary_containers
                    other: Container(
                      child: Text(
                        context.locale.languageCode.toUpperCase(),
                        style:
                            GoogleFonts.lato(fontSize: 16, color: Style.grey),
                      ),
                    ),
                    showBorders: const {
                      'top': false,
                      'bottom': false,
                    },
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            CustomMenuItem(
              label: 'logout'.tr(),
              onTap: () {
                event.logoutAccount(context);
              },
              showBorders: const {
                'top': true,
                'bottom': true,
              },
            ),
            10.verticalSpace,
            Text(
              '${'appversion'.tr()}: v${AppConstants.appVersion}',
              style: GoogleFonts.lato(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

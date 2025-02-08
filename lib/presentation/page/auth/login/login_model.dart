import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/login/login_provider.dart';
import 'package:listing/infrastructure/service/app_assets.dart';
import 'package:listing/presentation/components/custom_line_button.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:remixicon/remixicon.dart';

class LoginModelPage extends ConsumerWidget {
  const LoginModelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.read(loginProvider.notifier);
    // ignore: unused_local_variable
    final state = ref.watch(loginProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'login'.tr(),
          style: GoogleFonts.lato(fontSize: 18, color: Style.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              overlayColor: WidgetStateProperty.all(Style.transparent),
              child: const Icon(
                Remix.close_line,
                color: Style.grey,
                size: 24,
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Style.black.withOpacity(0.2), height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            if (Platform.isIOS)
              Column(
                children: [
                  CustomLineButton(
                      svg: SvgPicture.asset(
                        AppAssets.applelogo,
                        height: 25,
                      ),
                      title: 'continuetoapple'.tr(),
                      borderColor: Style.grey,
                      textColor: Style.black,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        event.loginWithApple(context);
                      }),
                  5.verticalSpace,
                ],
              ),
            // CustomLineButton(
            //     svg: SvgPicture.asset(
            //       AppAssets.facebooklogo,
            //       height: 25,
            //     ),
            //     title: 'continuetofacebook'.tr(),
            //     borderColor: Style.grey,
            //     fontWeight: FontWeight.w500,
            //     textColor: Style.black,
            //     onPressed: () {
            //       event.loginWithFacebook(context);
            //     }),
            5.verticalSpace,
            CustomLineButton(
                svg: SvgPicture.asset(
                  AppAssets.googlelogo,
                  height: 25,
                ),
                title: 'continuetogoogle'.tr(),
                borderColor: Style.grey,
                textColor: Style.black,
                fontWeight: FontWeight.w500,
                onPressed: () {
                  event.loginWithGoogle(context);
                }),
            20.verticalSpace,
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'or'.tr(),
                    style: GoogleFonts.lato(fontSize: 16),
                  ),
                  TextSpan(
                    text: ' ${'email'.tr()} ',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.router.push(const LoginRoute());
                      },
                    style:
                        GoogleFonts.lato(fontSize: 16, color: Style.mainColor),
                  ),
                  TextSpan(
                    text: 'orcontinuemail'.tr(),
                    style: GoogleFonts.lato(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

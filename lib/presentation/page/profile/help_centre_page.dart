import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/infrastructure/service/app_constants.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class HelpCentrePage extends ConsumerStatefulWidget {
  const HelpCentrePage({super.key});

  @override
  ConsumerState<HelpCentrePage> createState() => _HelpCentrePageState();
}

class _HelpCentrePageState extends ConsumerState<HelpCentrePage> {
  Future<void> launchWhatsApp() async {
    const whatsappUrl = AppConstants.whatsapp;

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      if (kDebugMode) {
        print('WhatsApp Error');
      }
    }
  }

  Future<void> launchEmail() async {
    const emailUrl = AppConstants.email;

    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      if (kDebugMode) {
        print('Email Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: CustomAppBar(label: 'helpcentre'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    child: profileState.avatar != null &&
                            profileState.avatar!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              profileState.avatar!,
                              fit: BoxFit.cover,
                              width: size.width,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text(
                                profileState.username.isNotEmpty
                                    ? profileState.username[0].toUpperCase()
                                    : '',
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Style.black),
                              ),
                            ),
                          )
                        : Text(
                            profileState.username.isNotEmpty
                                ? profileState.username[0].toUpperCase()
                                : '',
                            style: GoogleFonts.lato(
                                fontSize: 18, color: Style.black),
                          ),
                  ),
                  10.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "${'hello'.tr()}!",
                          style: GoogleFonts.lato(fontSize: 18),
                          children: [
                            TextSpan(
                              text: ' ${profileState.fullname!}',
                              style: GoogleFonts.lato(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '@${profileState.username}',
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Style.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              20.verticalSpace,
              InkWell(
                onTap: () {
                  context.pushRoute(const FaqRoute());
                },
                overlayColor: WidgetStateProperty.all(Style.transparent),
                child: Container(
                  height: size.height * 0.12,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: Style.bgGrey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Remix.question_line,
                          size: size.height * 0.04,
                          color: Style.mainColor,
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'faq'.tr(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(fontSize: 16),
                              ),
                              5.verticalSpace,
                              Text(
                                'faqtext'.tr(),
                                textAlign: TextAlign.left,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                    fontSize: 14, color: Style.hintColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
              // InkWell(
              //   onTap: () {},
              //   overlayColor: WidgetStateProperty.all(Style.transparent),
              //   child: Container(
              //     height: size.height * 0.12,
              //     width: size.width,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(8),
              //         border: Border.all(width: 1, color: Style.bgGrey)),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Row(
              //         children: [
              //           Icon(
              //             Remix.bubble_chart_line,
              //             size: size.height * 0.04,
              //             color: Style.mainColor,
              //           ),
              //           10.horizontalSpace,
              //           Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text(
              //                   'ai'.tr(),
              //                   textAlign: TextAlign.center,
              //                   style: GoogleFonts.lato(fontSize: 16),
              //                 ),
              //                 5.verticalSpace,
              //                 Text(
              //                   'aitext'.tr(),
              //                   textAlign: TextAlign.left,
              //                   maxLines: 3,
              //                   overflow: TextOverflow.ellipsis,
              //                   style: GoogleFonts.lato(
              //                       fontSize: 14, color: Style.hintColor),
              //                 ),
              //               ],
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // 10.verticalSpace,
              InkWell(
                onTap: launchWhatsApp,
                overlayColor: WidgetStateProperty.all(Style.transparent),
                child: Container(
                  height: size.height * 0.12,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: Style.bgGrey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Remix.whatsapp_line,
                          size: size.height * 0.04,
                          color: Style.mainColor,
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'whatsapp'.tr(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(fontSize: 16),
                              ),
                              5.verticalSpace,
                              Text(
                                'whatsapptext'.tr(),
                                textAlign: TextAlign.left,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                    fontSize: 14, color: Style.hintColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
              InkWell(
                onTap: launchEmail,
                overlayColor: WidgetStateProperty.all(Style.transparent),
                child: Container(
                  height: size.height * 0.12,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: Style.bgGrey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Remix.mail_send_line,
                          size: size.height * 0.04,
                          color: Style.mainColor,
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'email'.tr(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(fontSize: 16),
                              ),
                              5.verticalSpace,
                              Text(
                                'emailtext'.tr(),
                                textAlign: TextAlign.left,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                    fontSize: 14, color: Style.hintColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

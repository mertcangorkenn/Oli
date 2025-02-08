import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<AccountSettingsPage> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getProfileDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    Size size = MediaQuery.of(context).size;

    String providerInfo = auth.currentUser!.providerData
        .map((userInfo) => userInfo.providerId)
        .join(', ');

    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: CustomAppBar(label: 'accountsettings'.tr()),
      body: Column(
        children: [
          Container(
            height: size.height * 0.07,
            width: size.width,
            decoration: const BoxDecoration(
                color: Style.white,
                border:
                    Border(bottom: BorderSide(width: 1, color: Style.bgGrey))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'username'.tr(),
                    textAlign: TextAlign.left,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
                  ),
                  Text(
                    state.username,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Style.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          // 10.verticalSpace,
          // Container(
          //   height: size.height * 0.07,
          //   width: size.width,
          //   decoration: BoxDecoration(
          //       color: Style.white,
          //       border: Border.all(color: Style.bgGrey, width: 1)),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'phonenumber'.tr(),
          //           textAlign: TextAlign.left,
          //           style:
          //               GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
          //         ),
          //         Text(
          //           state.phonenumber!,
          //           style: GoogleFonts.lato(
          //               fontSize: 18,
          //               color: Style.black,
          //               fontWeight: FontWeight.normal),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // 5.verticalSpace,
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Text(
          //     'phonenumberusedtext'.tr(),
          //     textAlign: TextAlign.left,
          //     style: GoogleFonts.lato(
          //       fontSize: 14,
          //       color: Style.grey,
          //     ),
          //   ),
          // ),
          10.verticalSpace,
          Container(
            height: size.height * 0.07,
            width: size.width,
            decoration: BoxDecoration(
                color: Style.white,
                border: Border.all(color: Style.bgGrey, width: 1)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'fullname'.tr(),
                    textAlign: TextAlign.left,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
                  ),
                  Text(
                    state.fullname!,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Style.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: size.height * 0.07,
            width: size.width,
            decoration: const BoxDecoration(
                color: Style.white,
                border:
                    Border(bottom: BorderSide(width: 1, color: Style.bgGrey))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'email'.tr(),
                    textAlign: TextAlign.left,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
                  ),
                  Text(
                    state.email,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Style.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: size.height * 0.07,
            width: size.width,
            decoration: const BoxDecoration(
                color: Style.white,
                border:
                    Border(bottom: BorderSide(width: 1, color: Style.bgGrey))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'gender'.tr(),
                    textAlign: TextAlign.left,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
                  ),
                  Text(
                    state.gender!,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Style.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: size.height * 0.07,
            width: size.width,
            decoration: const BoxDecoration(
                color: Style.white,
                border:
                    Border(bottom: BorderSide(width: 1, color: Style.bgGrey))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('birthday'.tr(),
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                          fontSize: 14, color: Style.hintColor)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat('dd MMM yyyy').format(selectedDate!)
                            : state.formattedBirthday.toString(),
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Style.black,
                            fontWeight: FontWeight.normal),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              minTime: DateTime(1900, 1, 1),
                              currentTime: DateTime.now(),
                              maxTime: DateTime.now(),
                              showTitleActions: true, onChanged: (date) {
                            if (kDebugMode) {
                              print(date);
                            }
                            setState(() {
                              selectedDate = date;
                            });
                          }, onConfirm: (date) {
                            ref
                                .read(profileProvider.notifier)
                                .updateProfile(birthday: date);
                            setState(() {});
                          });
                        },
                        child: const Icon(
                          Remix.arrow_drop_down_line,
                          color: Style.hintColor,
                          size: 24,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          10.verticalSpace,
          Container(
            height: size.height * 0.07,
            width: size.width,
            decoration: BoxDecoration(
                color: Style.white,
                border: Border.all(width: 1, color: Style.bgGrey)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'createdaccount'.tr(),
                    textAlign: TextAlign.left,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
                  ),
                  Text(
                    state.formattedCreated.toString(),
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Style.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: size.height * 0.07,
            width: size.width,
            decoration: const BoxDecoration(
                color: Style.white,
                border:
                    Border(bottom: BorderSide(width: 1, color: Style.bgGrey))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'verifiedinfo'.tr(),
                    textAlign: TextAlign.left,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
                  ),
                  Text(
                    providerInfo,
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Style.black,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          10.verticalSpace,
          CustomMenuItem(
            label: 'deletemyaccount'.tr(),
            onTap: () {
              context.pushRoute(const DeleteAccountRoute());
            },
            showBorders: const {
              'top': true,
              'bottom': true,
            },
          ),
        ],
      ),
    );
  }
}

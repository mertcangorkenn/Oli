import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/infrastructure/service/app_helpers.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/auth/register/select_location_page.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class ProfileDetailsPage extends ConsumerStatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  ConsumerState<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends ConsumerState<ProfileDetailsPage> {
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getProfileDetails();
    });
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final state = ref.watch(profileProvider);

    if (bioController.text != state.bio) {
      bioController.text = state.bio ?? '';
    }

    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: CustomAppBar(label: 'profiledetails'.tr()),
      body: Column(
        children: [
          InkWell(
            onTap: () async {
              await ref.read(profileProvider.notifier).uploadProfilePicture();
            },
            child: Container(
              height: size.height * 0.1,
              width: size.width,
              decoration: const BoxDecoration(
                  color: Style.white,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Style.bgGrey))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor: Style.mainColor,
                          child: state.avatar != null &&
                                  state.avatar!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    state.avatar!,
                                    fit: BoxFit.cover,
                                    width: 50.r,
                                    height: 50.r,
                                    errorBuilder:
                                        (context, error, stackTrace) => Text(
                                      state.username.isNotEmpty
                                          ? state.username[0].toUpperCase()
                                          : '',
                                      style: GoogleFonts.lato(
                                          fontSize: 20, color: Style.black),
                                    ),
                                  ),
                                )
                              : Text(
                                  state.username.isNotEmpty
                                      ? state.username[0].toUpperCase()
                                      : '',
                                  style: GoogleFonts.lato(
                                      fontSize: 20, color: Style.black),
                                ),
                        ),
                        10.horizontalSpace,
                      ],
                    ),
                    Text(
                      'changePhoto'.tr(),
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Style.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Remix.arrow_right_s_line,
                      color: Style.hintColor,
                      size: 24.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.25,
            width: size.width,
            decoration: const BoxDecoration(
                color: Style.white,
                border: Border(
                    bottom: BorderSide(
                  width: 1,
                  color: Style.bgGrey,
                ))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'aboutme'.tr(),
                    textAlign: TextAlign.left,
                    style:
                        GoogleFonts.lato(fontSize: 14, color: Style.hintColor),
                  ),
                  TextFormField(
                    maxLines: 6,
                    controller: bioController,
                    maxLength: 125,
                    style: GoogleFonts.lato(fontSize: 14, color: Style.black),
                    decoration: InputDecoration(
                        hintStyle:
                            GoogleFonts.lato(fontSize: 14, color: Style.black),
                        hintText: 'tellusyourself'.tr(),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey)),
                        errorBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey)),
                        disabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey)),
                        focusedErrorBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Style.bgGrey))),
                  ),
                ],
              ),
            ),
          ),
          10.verticalSpace,
          CustomMenuItem(
            label: 'mylocation'.tr(),
            onTap: () {
              AppHelpers.showCustomModalBottomSheet(
                  context: context,
                  paddingTop: size.height * 0.6,
                  modal: const SelectLocationPage());
            },
            // ignore: avoid_unnecessary_containers
            other: Container(
              child: Text(
                state.location.tr(),
                style: GoogleFonts.lato(fontSize: 16, color: Style.grey),
              ),
            ),
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

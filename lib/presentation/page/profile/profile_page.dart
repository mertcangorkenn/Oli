import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getProfileDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final state = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'profile'.tr(),
          style: GoogleFonts.lato(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                context.pushRoute(const ProfileDetailRoute());
              },
              child: Container(
                height: size.height * 0.1,
                width: size.width,
                decoration: BoxDecoration(
                  color: Style.white,
                  border:
                      Border.all(width: 1, color: Style.black.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Style.mainColor,
                        child: state.avatar != null && state.avatar!.isNotEmpty
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: state.avatar!,
                                  width: 50.r,
                                  height: 50.r,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(
                                    color: Style.black,
                                  ),
                                  errorWidget: (context, url, error) => Text(
                                    state.username.isNotEmpty
                                        ? state.username[0].toUpperCase()
                                        : '',
                                    style: GoogleFonts.lato(
                                      fontSize: 20,
                                      color: Style.black,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                state.username.isNotEmpty
                                    ? state.username[0].toUpperCase()
                                    : '',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  color: Style.black,
                                ),
                              ),
                      ),
                      10.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.username,
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Style.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text('viewmyprofile'.tr(),
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Style.hintColor,
                              )),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Remix.arrow_right_s_line,
                        color: Style.hintColor,
                        size: 24,
                      )
                    ],
                  ),
                ),
              ),
            ),
            10.verticalSpace,
            CustomMenuItem(
              icon: Remix.heart_line,
              label: 'favourites'.tr(),
              onTap: () {
                context.pushRoute(const FavouriteRoute());
              },
              showBorders: const {
                'top': true,
                'bottom': true,
              },
            ),
            // CustomMenuItem(
            //   icon: Remix.equalizer_line,
            //   label: 'personalisation'.tr(),
            //   onTap: () {
            //     context.pushRoute(const PersonalisationRoute());
            //   },
            //   showBorders: const {
            //     'top': false,
            //     'bottom': true,
            //   },
            // ),
            CustomMenuItem(
              icon: Remix.umbrella_line,
              label: 'holidaymode'.tr(),
              onTap: () {
                context.pushRoute(const HolidayModeRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            10.verticalSpace,
            CustomMenuItem(
              icon: Remix.settings_2_line,
              label: 'settings'.tr(),
              onTap: () {
                context.pushRoute(const SettingsRoute());
              },
              showBorders: const {
                'top': true,
                'bottom': true,
              },
            ),
            CustomMenuItem(
              icon: Remix.question_line,
              label: 'helpcentre'.tr(),
              onTap: () {
                context.pushRoute(const HelpCentreRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            CustomMenuItem(
              icon: Remix.git_repository_private_line,
              label: 'privacypolicy'.tr(),
              onTap: () {
                context.pushRoute(const PrivacyPolicyRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            CustomMenuItem(
              icon: Remix.book_3_line,
              label: 'terms'.tr(),
              onTap: () {
                context.pushRoute(const TermsRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            CustomMenuItem(
              icon: Remix.book_3_line,
              label: 'legalinformation'.tr(),
              onTap: () {
                context.pushRoute(const LegalInformationRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            CustomMenuItem(
              icon: Remix.user_smile_line,
              label: 'sendyourfeedback'.tr(),
              onTap: () {
                context.pushRoute(const FeedbackRoute());
              },
              showBorders: const {
                'top': false,
                'bottom': true,
              },
            ),
            10.verticalSpace,
            Text(
              '© ${'allrightsreserved'.tr()}.',
              style: GoogleFonts.lato(color: Style.hintColor),
            ),
            10.verticalSpace
          ],
        ),
      ),
    );
  }
}

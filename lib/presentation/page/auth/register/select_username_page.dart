import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/register/register_provider.dart';
import 'package:listing/infrastructure/service/app_helpers.dart';
import 'package:listing/infrastructure/service/app_validators.dart';
import 'package:listing/infrastructure/service/local_storage.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/components/outline_bordered_text_field.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class SelectUsernamePage extends ConsumerStatefulWidget {
  const SelectUsernamePage({super.key});

  @override
  ConsumerState<SelectUsernamePage> createState() => _SelectUsernamePageState();
}

class _SelectUsernamePageState extends ConsumerState<SelectUsernamePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(auth.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(registerProvider.notifier);
    final state = ref.watch(registerProvider);
    return Scaffold(
      appBar: CustomAppBar(
        label: 'enterinfo'.tr(),
        onPressed: () async {
          auth.signOut();
          LocalStorage.deleteToken();
          await context.replaceRoute(const LandingRoute());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            OutlinedBorderTextField(
              hint: 'fullname'.tr(),
              onChanged: event.setFullname,
              suffixIcon: state.isFullnameInvalid
                  ? const Icon(
                      Remix.close_line,
                      color: Style.red,
                      size: 16,
                    )
                  : (AppValidators.checkName(state.fullname) == null
                      ? const Icon(
                          Remix.check_double_line,
                          color: Style.mainColor,
                          size: 16,
                        )
                      : null),
              descriptionText: state.isFullnameInvalid
                  ? 'fullnameInvalidError'.tr()
                  : AppValidators.checkName(state.fullname) ?? '',
            ),
            10.verticalSpace,
            OutlinedBorderTextField(
              hint: 'username'.tr(),
              onChanged: (username) async {
                event.setUsername(username);
                final validationMessage = AppValidators.checkUsername(username);
                if (validationMessage == null) {
                  await event.checkUsernameExists(username);
                }
                setState(() {});
              },
              suffixIcon: state.isUsernameInvalid
                  ? const Icon(Remix.close_line, color: Style.red, size: 16)
                  : (AppValidators.isValidUsername(state.username)
                      ? const Icon(Remix.check_double_line,
                          color: Style.mainColor, size: 16)
                      : null),
              descriptionText: state.isUsernameInvalid
                  ? 'usernamealreadyexists'.tr()
                  : AppValidators.checkUsername(state.username) ?? '',
            ),
            20.verticalSpace,
            CustomButton(
              title: 'continue'.tr(),
              isLoading: state.isLoading,
              onPressed: () async {
                if (state.isUsernameInvalid) {
                  AppHelpers.showCheckTopSnackBar(
                      context, 'usernameInvalidError'.tr());
                  return;
                }

                if (auth.currentUser == null) {
                  AppHelpers.showCheckTopSnackBar(
                      context, 'userNotLoggedInError'.tr());
                  return;
                }

                final validationMessage =
                    AppValidators.checkUsername(state.username);

                if (validationMessage != null) {
                  AppHelpers.showCheckTopSnackBar(context, validationMessage);
                  return;
                }

                final fullnameValidationMessage =
                    AppValidators.checkName(state.fullname);

                if (fullnameValidationMessage != null) {
                  AppHelpers.showCheckTopSnackBar(
                      context, fullnameValidationMessage);
                  return;
                }

                try {
                  await event.changeUsername(auth.currentUser!.uid);
                  await event.setName(auth.currentUser!.uid);
                  // ignore: use_build_context_synchronously
                  context.replaceRoute(const SelectLocationRoute());
                } catch (e) {
                  AppHelpers.showCheckTopSnackBar(
                      // ignore: use_build_context_synchronously
                      context,
                      'usernameChangeError'.tr());
                }
              },
            ),
            10.verticalSpace,
            Text(
              '*${'usernamecannotbechanged'.tr()}',
              style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Style.black),
            )
          ],
        ),
      ),
    );
  }
}

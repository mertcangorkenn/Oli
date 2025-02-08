import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/register/register_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/components/outline_bordered_text_field.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    final event = ref.read(registerProvider.notifier);
    final state = ref.watch(registerProvider);

    return Scaffold(
      appBar: CustomAppBar(label: 'register'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            OutlinedBorderTextField(
              hint: 'username'.tr(),
              onChanged: event.setUsername,
              isError: state.isUsernameInvalid,
              descriptionText:
                  state.isUsernameInvalid ? 'isUsernameInvalid'.tr() : null,
            ),
            20.verticalSpace,
            OutlinedBorderTextField(
              hint: 'email'.tr(),
              onChanged: event.setEmail,
              isError: state.isEmailInvalid,
              descriptionText:
                  state.isEmailInvalid ? 'isEmailInvalid'.tr() : null,
            ),
            20.verticalSpace,
            OutlinedBorderTextField(
              hint: 'password'.tr(),
              obscure: state.showPassword,
              suffixIcon: IconButton(
                  onPressed: () => event.toggleShowPassword(),
                  icon: Icon(
                      state.showPassword
                          ? Remix.eye_line
                          : Remix.eye_close_line,
                      size: 18,
                      color: Style.grey)),
              onChanged: event.setPassword,
              isError: state.isPasswordInvalid,
              descriptionText: state.isPasswordInvalid
                  ? 'passwordShouldContainMinimum8Characters'.tr()
                  : null,
            ),
            20.verticalSpace,
            Text('termsText'.tr(),
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Style.black,
                )),
            20.verticalSpace,
            CustomButton(
              isLoading: state.isLoading,
              title: 'register'.tr(),
              onPressed: () {
                event.checkEmail() && event.checkUsername()
                    ? event.register(context)
                    : null;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: size.height * 0.1,
        child: Center(
          child: InkWell(
            onTap: () {},
            overlayColor: WidgetStateProperty.all(Style.transparent),
            child: Text(
              'havingtrouble'.tr(),
              style: GoogleFonts.lato(color: Style.mainColor, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/login/login_provider.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/components/keyboard_dismisser.dart';
import 'package:listing/presentation/components/outline_bordered_text_field.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:remixicon/remixicon.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();
    Size size = MediaQuery.of(context).size;

    final event = ref.read(loginProvider.notifier);
    final state = ref.watch(loginProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              context.back();
            },
            icon: const Icon(Remix.arrow_left_line,
                size: 24, color: Style.black)),
        title: Text(
          'login'.tr(),
          style: GoogleFonts.lato(fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Style.black.withOpacity(0.2), height: 1),
        ),
      ),
      body: KeyboardDismisser(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              OutlinedBorderTextField(
                hint: 'email'.tr(),
                onChanged: event.setEmail,
                isError: state.isEmailNotValid,
              ),
              20.verticalSpace,
              OutlinedBorderTextField(
                hint: 'password'.tr(),
                obscure: state.showPassword,
                suffixIcon: IconButton(
                    onPressed: () => event.setShowPassword(!state.showPassword),
                    icon: Icon(
                        state.showPassword
                            ? Remix.eye_line
                            : Remix.eye_close_line,
                        size: 18,
                        color: Style.grey)),
                onChanged: event.setPassword,
                isError: state.isPasswordNotValid,
              ),
              20.verticalSpace,
              CustomButton(
                isLoading: state.isLoading,
                title: 'login'.tr(),
                onPressed: () {
                  if (key.currentState?.validate() ?? false) {
                    event.login(context);
                  }
                },
              ),
              10.verticalSpace,
              InkWell(
                onTap: () {
                  context.pushRoute(const ForgotPasswordRoute());
                },
                overlayColor: WidgetStateProperty.all(Style.transparent),
                child: Text(
                  'forgotPassword'.tr(),
                  style: GoogleFonts.lato(color: Style.mainColor, fontSize: 16),
                ),
              ),
            ],
          ),
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

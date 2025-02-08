import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/components/outline_bordered_text_field.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:remixicon/remixicon.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
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
          'forgotPassword'.tr(),
          style: GoogleFonts.lato(fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Style.black.withOpacity(0.2), height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            OutlinedBorderTextField(hint: 'email'.tr()),
            20.verticalSpace,
            CustomButton(title: 'continue'.tr(), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

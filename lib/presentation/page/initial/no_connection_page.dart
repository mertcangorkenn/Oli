import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/components/custom_line_button.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class NoConnectionPage extends ConsumerWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Remix.cloud_windy_line,
                size: 100,
                color: Style.mainColor,
              ),
              20.verticalSpace,
              Text(
                'noconnection'.tr(),
                style:
                    GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'noconnectiontext'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 16, color: Style.hintColor),
              ),
              20.verticalSpace,
              SizedBox(
                  width: size.height * 0.3,
                  child:
                      CustomLineButton(title: 'retry'.tr(), onPressed: () {}))
            ],
          ),
        ),
      ),
    );
  }
}

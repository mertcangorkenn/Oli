import 'package:auto_route/auto_route.dart';
import 'package:country_codes/country_codes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/infrastructure/service/app_assets.dart';
import 'package:listing/infrastructure/service/app_helpers.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/components/custom_line_button.dart';
import 'package:listing/presentation/components/language_change_page.dart';
import 'package:listing/presentation/page/auth/login/login_model.dart';
import 'package:listing/presentation/page/auth/register/register_model.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<String> image = [
    AppAssets.image1,
    AppAssets.image2,
    AppAssets.image3,
    AppAssets.image4,
    AppAssets.image5,
    AppAssets.image6,
    AppAssets.image7,
    AppAssets.image8,
    AppAssets.image9,
    AppAssets.image10,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CountryDetails? details = CountryCodes.detailsForLocale(context.locale);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () {
              AppHelpers.showCustomModalBottomSheet(
                context: context,
                paddingTop: size.height * 0.6,
                modal: const LanguageChangePage(),
              );
            },
            overlayColor: WidgetStateProperty.all(Style.transparent),
            child: Row(
              children: [
                const Icon(Icons.language, color: Style.black, size: 24),
                8.horizontalSpace,
                Text(
                  '${details.localizedName}, ${context.locale.languageCode.toUpperCase()}',
                  style: GoogleFonts.lato(fontSize: 16, color: Style.black),
                ),
                const Icon(Icons.arrow_drop_down, color: Style.black, size: 24),
              ],
            ),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Style.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.5,
                child: Stack(
                  children: [
                    MasonryGridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemCount: image.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  Image.asset(image[index], fit: BoxFit.cover)),
                        );
                      },
                    ),
                    Positioned.fill(
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.white.withOpacity(0),
                                Colors.white.withOpacity(0),
                                Colors.white.withOpacity(0.8),
                              ])),
                        ))
                  ],
                ),
              ),
              20.verticalSpace,
              Text(
                'landText'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Style.black,
                ),
              ),
              20.verticalSpace,
              CustomButton(
                  title: 'signupfor'.tr(),
                  onPressed: () {
                    AppHelpers.showCustomModalBottomSheet(
                        context: context,
                        paddingTop: size.height * 0.65,
                        modal: const RegisterModelPage());
                  }),
              10.verticalSpace,
              CustomLineButton(
                  title: 'haveAccount'.tr(),
                  onPressed: () {
                    AppHelpers.showCustomModalBottomSheet(
                        context: context,
                        paddingTop: size.height * 0.65,
                        modal: const LoginModelPage());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

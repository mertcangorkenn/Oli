import 'package:auto_route/auto_route.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:country_codes/country_codes.dart';
import 'package:remixicon/remixicon.dart';

@RoutePage()
class LanguageChangePage extends StatefulWidget {
  const LanguageChangePage({super.key});

  @override
  State<LanguageChangePage> createState() => _LanguageChangePageState();
}

class _LanguageChangePageState extends State<LanguageChangePage> {
  List<Locale> supportedLocales = [];
  Locale? currentLocale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeCountryCodes();
    });
  }

  void initializeCountryCodes() {
    supportedLocales = EasyLocalization.of(context)!.supportedLocales;
    setState(() {
      currentLocale = context.locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'selectLanguage'.tr(),
          style: GoogleFonts.lato(fontSize: 18.r, color: Style.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.r),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              overlayColor: WidgetStateProperty.all(Style.transparent),
              child: Icon(
                Remix.close_line,
                color: Style.grey,
                size: 24.r,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Style.black.withOpacity(0.2), height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: supportedLocales.map((locale) {
                CountryDetails? details = CountryCodes.detailsForLocale(locale);
                // ignore: unnecessary_null_comparison
                String? countryName = details != null
                    ? details.localizedName ?? details.name
                    : 'Unknown';
                bool isSelected = locale == currentLocale;
                return InkWell(
                  onTap: () {
                    context.setLocale(locale);
                    setState(() {
                      currentLocale = locale;
                    });
                    Navigator.pop(context);
                  },
                  overlayColor: WidgetStateProperty.all(Style.transparent),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.r),
                    child: Row(
                      children: [
                        CountryFlag.fromCountryCode(
                          locale.countryCode.toString(),
                          shape: const Circle(),
                          width: size.height * 0.04,
                          height: size.height * 0.04,
                        ),
                        10.horizontalSpace,
                        Text(
                          '$countryName (${locale.languageCode.toUpperCase()})',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: isSelected ? Style.mainColor : Style.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        )),
      ),
    );
  }
}

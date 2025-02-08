import 'package:auto_route/auto_route.dart';
import 'package:country_flags/country_flags.dart';
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
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class SelectLocationPage extends ConsumerStatefulWidget {
  const SelectLocationPage({super.key});

  @override
  ConsumerState<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends ConsumerState<SelectLocationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<Map<String, String>> countries = [
    {'code': 'TR', 'name': 'Turkey'},
    {'code': 'CY', 'name': 'Cyprus'},
    {'code': 'AT', 'name': 'Austria'},
    {'code': 'BE', 'name': 'Belgium'},
    {'code': 'BG', 'name': 'Bulgaria'},
    {'code': 'HR', 'name': 'Croatia'},
    {'code': 'CZ', 'name': 'CzechRepublic'},
    {'code': 'DK', 'name': 'Denmark'},
    {'code': 'EE', 'name': 'Estonia'},
    {'code': 'FI', 'name': 'Finland'},
    {'code': 'FR', 'name': 'France'},
    {'code': 'DE', 'name': 'Germany'},
    {'code': 'GR', 'name': 'Greece'},
    {'code': 'HU', 'name': 'Hungary'},
    {'code': 'IE', 'name': 'Ireland'},
    {'code': 'IT', 'name': 'Italy'},
    {'code': 'LV', 'name': 'Latvia'},
    {'code': 'LT', 'name': 'Lithuania'},
    {'code': 'LU', 'name': 'Luxembourg'},
    {'code': 'MT', 'name': 'Malta'},
    {'code': 'NL', 'name': 'Netherlands'},
    {'code': 'PL', 'name': 'Poland'},
    {'code': 'PT', 'name': 'Portugal'},
    {'code': 'RO', 'name': 'Romania'},
    {'code': 'SK', 'name': 'Slovakia'},
    {'code': 'SI', 'name': 'Slovenia'},
    {'code': 'ES', 'name': 'Spain'},
    {'code': 'SE', 'name': 'Sweden'},
    {'code': 'CH', 'name': 'Switzerland'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final event = ref.read(registerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'wheredoyoulive'.tr(),
            style: GoogleFonts.lato(fontSize: 20, color: Style.black),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index];
            return Container(
              height: size.height * 0.07,
              decoration: BoxDecoration(
                  color: Style.white,
                  border: Border(
                      bottom: BorderSide(
                    width: 1,
                    color: Style.black.withOpacity(0.2),
                  ))),
              child: InkWell(
                onTap: () async {
                  if (auth.currentUser != null) {
                    try {
                      if (kDebugMode) {
                        print(auth.currentUser!.uid + country['name']!);
                      }
                      await event.selectLocation(
                          auth.currentUser!.uid, country['name']!);
                      // ignore: use_build_context_synchronously
                      await context.replaceRoute(const MainRoute());
                    } catch (e) {
                      AppHelpers.showCheckTopSnackBar(
                          // ignore: use_build_context_synchronously
                          context,
                          '$e');
                    }
                  } else {
                    AppHelpers.showCheckTopSnackBar(
                        context, 'userNotLoggedInError'.tr());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      CountryFlag.fromCountryCode(
                        country['code']!,
                        shape: const Circle(),
                      ),
                      10.horizontalSpace,
                      Text(
                        country['name']!.tr(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Style.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Remix.arrow_right_s_line,
                        color: Style.black.withOpacity(0.2),
                        size: 24.r,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class HolidayModePage extends ConsumerStatefulWidget {
  const HolidayModePage({super.key});

  @override
  ConsumerState<HolidayModePage> createState() => _HolidayModePageState();
}

class _HolidayModePageState extends ConsumerState<HolidayModePage> {
  final ValueNotifier<bool> switchController = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(profileProvider);
      if (profileState.holidaymode != null) {
        switchController.value = profileState.holidaymode!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: 'holidaymode'.tr()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomMenuItem(
            label: 'holidaymode'.tr(),
            onTap: () {},
            // ignore: avoid_unnecessary_containers
            suffix: Container(
              child: AdvancedSwitch(
                controller: switchController,
                activeColor: Style.mainColor,
                onChanged: (value) async {
                  await ref
                      .read(profileProvider.notifier)
                      .holidayMode(holidayMode: value);
                },
              ),
            ),
            showBorders: const {'top': false, 'bottom': true},
          ),
          10.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text(
                  'holidaymode_explanation_body'.tr(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Style.grey,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'holidaymode_explanation_note'.tr(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Style.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    switchController.dispose();
    super.dispose();
  }
}

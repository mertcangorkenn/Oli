import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';

@RoutePage()
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: 'notification'.tr()),
      body: Column(
        children: [
          CustomMenuItem(
            label: 'notification'.tr(),
            onTap: () {},
            // ignore: avoid_unnecessary_containers
            suffix: Container(
              child: const AdvancedSwitch(),
            ),
            showBorders: const {'top': false, 'bottom': true},
          ),
        ],
      ),
    );
  }
}

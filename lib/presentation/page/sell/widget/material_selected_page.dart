import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class MaterialSelectedPage extends ConsumerStatefulWidget {
  const MaterialSelectedPage({super.key});

  @override
  ConsumerState<MaterialSelectedPage> createState() =>
      _MaterialSelectedPageState();
}

class _MaterialSelectedPageState extends ConsumerState<MaterialSelectedPage> {
  List<Map<String, dynamic>> materials = [
    {'id': 'cotton', 'name': 'cotton'.tr()},
    {'id': 'chiffon', 'name': 'chiffon'.tr()},
    {'id': 'viscose', 'name': 'viscose'.tr()},
    {'id': 'wool', 'name': 'wool'.tr()},
    {'id': 'silk', 'name': 'silk'.tr()},
    {'id': 'leather', 'name': 'leather'.tr()},
    {'id': 'denim', 'name': 'denim'.tr()},
    {'id': 'polyester', 'name': 'polyester'.tr()},
    {'id': 'nylon', 'name': 'nylon'.tr()},
    {'id': 'linen', 'name': 'linen'.tr()},
    {'id': 'velvet', 'name': 'velvet'.tr()},
    {'id': 'fleece', 'name': 'fleece'.tr()},
    {'id': 'cashmere', 'name': 'cashmere'.tr()},
    {'id': 'suede', 'name': 'suede'.tr()},
    {'id': 'satin', 'name': 'satin'.tr()},
    {'id': 'jersey', 'name': 'jersey'.tr()},
    {'id': 'ribbed', 'name': 'ribbed'.tr()},
    {'id': 'tweed', 'name': 'tweed'.tr()},
    {'id': 'fauxleather', 'name': 'fauxleather'.tr()},
    {'id': 'bamboo', 'name': 'bamboo'.tr()},
    {'id': 'sherpa', 'name': 'sherpa'.tr()},
    {'id': 'organiccotton', 'name': 'organiccotton'.tr()},
  ];

  bool isLoading = false;
  String? errorMessage;

  Future<void> handleMaterialSelection(String material) async {
    ref.read(sellProvider.notifier).setMaterial(material, material);
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellProvider);
    return Scaffold(
      appBar: CustomAppBar(label: 'material'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Style.mainColor,
              ))
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : materials.isEmpty
                    ? const Center(child: Text('No material available'))
                    : SingleChildScrollView(
                        child: Column(
                          children: materials.map((material) {
                            final isSelected =
                                sellState.materialId == material['id'];

                            return CustomMenuItem(
                              label: tr(material['name']),
                              onTap: () {
                                handleMaterialSelection(material['id']);
                              },
                              suffix: isSelected
                                  ? Text(
                                      'selected'.tr(),
                                      style: const TextStyle(
                                        color: Style.mainColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Container(),
                              showBorders: const {
                                'top': false,
                                'bottom': true,
                              },
                            );
                          }).toList(),
                        ),
                      ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class ColorSelectedPage extends ConsumerStatefulWidget {
  const ColorSelectedPage({super.key});

  @override
  ConsumerState<ColorSelectedPage> createState() => _ColorSelectedPageState();
}

class _ColorSelectedPageState extends ConsumerState<ColorSelectedPage> {
  List<Map<String, dynamic>> color = [
    {'id': 'beige', 'name': 'beige'.tr(), 'color': const Color(0xFFF5F5DC)},
    {'id': 'black', 'name': 'black'.tr(), 'color': const Color(0xFF000000)},
    {'id': 'brown', 'name': 'brown'.tr(), 'color': const Color(0xFFA52A2A)},
    {
      'id': 'colorized',
      'name': 'colorized'.tr(),
    },
    {'id': 'white', 'name': 'white'.tr(), 'color': const Color(0xFFFFFFFF)},
    {'id': 'khaki', 'name': 'khaki'.tr(), 'color': const Color(0xFFC3B091)},
    {'id': 'grey', 'name': 'grey'.tr(), 'color': const Color(0xFF808080)},
    {
      'id': 'burgundy',
      'name': 'burgundy'.tr(),
      'color': const Color(0xFF800020)
    },
    {
      'id': 'navyblue',
      'name': 'navyblue'.tr(),
      'color': const Color(0xFF000080)
    },
    {'id': 'red', 'name': 'red'.tr(), 'color': const Color(0xFFFF0000)},
    {
      'id': 'anthracite',
      'name': 'anthracite'.tr(),
      'color': const Color(0xFF2E2E2E)
    },
    {'id': 'taba', 'name': 'taba'.tr(), 'color': const Color(0xFFD2B48C)},
    {'id': 'cream', 'name': 'cream'.tr(), 'color': const Color(0xFFFFFDD0)},
    {'id': 'smoked', 'name': 'smoked'.tr(), 'color': const Color(0xFF708090)},
    {'id': 'mustard', 'name': 'mustard'.tr(), 'color': const Color(0xFFFFDB58)},
    {'id': 'tile', 'name': 'tile'.tr(), 'color': const Color(0xFFB22222)},
    {'id': 'silver', 'name': 'silver'.tr(), 'color': const Color(0xFFC0C0C0)},
    {
      'id': 'patterned',
      'name': 'patterned'.tr(),
      'color': const Color(0xFF8A2BE2)
    },
    {'id': 'yellow', 'name': 'yellow'.tr(), 'color': const Color(0xFFFFFF00)},
    {
      'id': 'turquoise',
      'name': 'turquoise'.tr(),
      'color': const Color(0xFF40E0D0)
    },
    {
      'id': 'pomegranate',
      'name': 'pomegranate'.tr(),
      'color': const Color(0xFFDC143C)
    },
    {'id': 'orange', 'name': 'orange'.tr(), 'color': const Color(0xFFFFA500)},
    {'id': 'striped', 'name': 'striped'.tr(), 'color': const Color(0xFF000000)},
    {'id': 'vizon', 'name': 'vizon'.tr(), 'color': const Color(0xFF8B4513)},
    {'id': 'pink', 'name': 'pink'.tr(), 'color': const Color(0xFFFFC0CB)},
    {'id': 'powder', 'name': 'powder'.tr(), 'color': const Color(0xFFE6E6FA)},
    {'id': 'zebra', 'name': 'zebra'.tr(), 'color': const Color(0xFF000000)},
    {'id': 'gold', 'name': 'gold'.tr(), 'color': const Color(0xFFFFD700)},
    {'id': 'somon', 'name': 'somon'.tr(), 'color': const Color(0xFFFFA07A)},
    {'id': 'straw', 'name': 'straw'.tr(), 'color': const Color(0xFFDEB887)},
    {'id': 'dots', 'name': 'dots'.tr(), 'color': const Color(0xFF000000)},
    {'id': 'blue', 'name': 'blue'.tr(), 'color': const Color(0xFF0000FF)},
    {'id': 'green', 'name': 'green'.tr(), 'color': const Color(0xFF008000)},
    {
      'id': 'transparent',
      'name': 'transparent'.tr(),
      'color': const Color(0x00FFFFFF)
    },
  ];

  bool isLoading = false;
  String? errorMessage;

  Future<void> handleColorSelection(String color) async {
    ref.read(sellProvider.notifier).setColor(color, color);
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellProvider);

    return Scaffold(
      appBar: CustomAppBar(label: 'colours'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Style.mainColor,
              ))
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : color.isEmpty
                    ? const Center(child: Text('No colors available'))
                    : SingleChildScrollView(
                        child: Column(
                          children: color.map((color) {
                            final isSelected = sellState.color == color['id'];

                            return CustomMenuItem(
                              prefix: CircleAvatar(
                                backgroundColor: color['color'],
                              ),
                              label: color['name'],
                              onTap: () {
                                handleColorSelection(color['id']);
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

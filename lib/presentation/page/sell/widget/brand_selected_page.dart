import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class BrandSelectedPage extends ConsumerStatefulWidget {
  const BrandSelectedPage({super.key});

  @override
  ConsumerState<BrandSelectedPage> createState() => _BrandSelectedPageState();
}

class _BrandSelectedPageState extends ConsumerState<BrandSelectedPage> {
  List<Map<String, dynamic>> brand = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadBrand();
    });
  }

  Future<void> loadBrand() async {
    try {
      final sellNotifier = ref.read(sellProvider.notifier);
      final fetchedBrand = await sellNotifier.fetchBrand();

      setState(() {
        brand = fetchedBrand;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> handleBrandSelection(String brand, String brandId) async {
    ref.read(sellProvider.notifier).setBrand(brand, brandId);
    if (kDebugMode) {
      print(brand);
      print(brandId);
    }
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellProvider);
    return Scaffold(
        appBar: CustomAppBar(label: 'brand'.tr()),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Style.mainColor,
                ))
              : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : brand.isEmpty
                      ? const Center(child: Text('No brand available'))
                      : SingleChildScrollView(
                          child: Column(
                            children: brand.map((brand) {
                              final isSelected =
                                  sellState.brandId == brand['id'];

                              return CustomMenuItem(
                                label: brand['name'],
                                onTap: () {
                                  handleBrandSelection(
                                      brand['name'], brand['id']);
                                },
                                suffix: isSelected
                                    ? const Text(
                                        'Seçildi',
                                        style: TextStyle(
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
        ));
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class SizeSelectedPage extends ConsumerStatefulWidget {
  const SizeSelectedPage({super.key});

  @override
  ConsumerState<SizeSelectedPage> createState() => _SizeSelectedPageState();
}

class _SizeSelectedPageState extends ConsumerState<SizeSelectedPage> {
  final List<Map<String, dynamic>> size = [
    {'id': '1', 'name': 'XXXS/30/2'},
    {'id': '2', 'name': 'XXS/32/4'},
    {'id': '3', 'name': 'XS/34/6'},
    {'id': '4', 'name': 'S/36/8'},
    {'id': '5', 'name': 'M/38/10'},
    {'id': '6', 'name': 'L/40/12'},
    {'id': '7', 'name': 'XL/42/14'},
    {'id': '8', 'name': 'XXL/44/16'},
    {'id': '9', 'name': 'XXXL/46/18'},
    {'id': '10', 'name': '4XL/48/20'},
    {'id': '11', 'name': '5XL/50/22'},
    {'id': '12', 'name': '6XL/52/24'},
    {'id': '13', 'name': '7XL/54/26'},
    {'id': '14', 'name': '8XL/56/28'},
    {'id': '15', 'name': '9XL/58/30'},
    {'id': '16', 'name': 'onesize'.tr()},
    {'id': '17', 'name': 'other'.tr()},
  ];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSizes();
    });
  }

  Future<void> loadSizes() async {
    try {
      // Simulating a delay to mimic network request
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> handleSizeSelection(String size, String sizeId) async {
    ref.read(sellProvider.notifier).setSize(size, sizeId);
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final sellState = ref.watch(sellProvider);
    return Scaffold(
      appBar: CustomAppBar(label: 'sizes'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Style.mainColor,
              ))
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : size.isEmpty
                    ? const Center(child: Text('No size available'))
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'selectsize'.tr(),
                                style: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text('selectsizetext'.tr(),
                                  style: GoogleFonts.lato(
                                      fontSize: 16, color: Style.grey)),
                            ),
                            10.verticalSpace,
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 20),
                            //   child: Text('viewsizeguide'.tr(),
                            //       style: GoogleFonts.lato(
                            //         fontSize: 16,
                            //         color: Style.mainColor,
                            //         decoration: TextDecoration.underline,
                            //         decorationColor: Style.mainColor,
                            //       )),
                            // ),
                            // 10.verticalSpace,
                            Column(
                              children: size.map((size) {
                                final isSelected =
                                    sellState.sizeId == size['id'];

                                return CustomMenuItem(
                                  label: size['name'],
                                  onTap: () {
                                    handleSizeSelection(
                                        size['name'], size['id']);
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
                            10.verticalSpace,
                          ],
                        ),
                      ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class SubcategorySelectedPage extends ConsumerStatefulWidget {
  final String categoryId;
  const SubcategorySelectedPage({super.key, required this.categoryId});

  @override
  ConsumerState<SubcategorySelectedPage> createState() =>
      _SubcategorySelectedPageState();
}

class _SubcategorySelectedPageState
    extends ConsumerState<SubcategorySelectedPage> {
  List<Map<String, dynamic>> subcategories = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSubcategories(widget.categoryId);
    });
  }

  Future<void> loadSubcategories(String categoryId) async {
    try {
      final sellNotifier = ref.read(sellProvider.notifier);
      final fetchedSubcategories =
          await sellNotifier.fetchSubCategories(categoryId);

      setState(() {
        subcategories = fetchedSubcategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> handleSubcategorySelection(
      String subcategoryId, String subcategoryName) async {
    ref
        .read(sellProvider.notifier)
        .setSubCategory(subcategoryName, subcategoryId);

    Navigator.of(context).popUntil((route) {
      return route.isFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: 'subcategory'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Style.mainColor,
              ))
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : subcategories.isEmpty
                    ? const Center(child: Text('No subcategories available'))
                    : Column(
                        children: subcategories.map((subcategory) {
                          return CustomMenuItem(
                            label: tr(subcategory['name']!),
                            onTap: () {
                              handleSubcategorySelection(
                                subcategory['id']!,
                                subcategory['name']!,
                              );
                            },
                            showBorders: const {
                              'top': false,
                              'bottom': true,
                            },
                            suffix: Container(),
                          );
                        }).toList(),
                      ),
      ),
    );
  }
}

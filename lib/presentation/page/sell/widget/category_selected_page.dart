import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class CategorySelectedPage extends ConsumerStatefulWidget {
  const CategorySelectedPage({super.key});

  @override
  ConsumerState<CategorySelectedPage> createState() =>
      _CategorySelectedPageState();
}

class _CategorySelectedPageState extends ConsumerState<CategorySelectedPage> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCategories();
    });
  }

  Future<void> loadCategories() async {
    try {
      final sellNotifier = ref.read(sellProvider.notifier);
      final fetchedCategories = await sellNotifier.fetchCategories();

      final categoryWithSubCategories =
          await Future.wait(fetchedCategories.map((category) async {
        final subCategories =
            await sellNotifier.fetchSubCategories(category['id']!);
        return {
          ...category,
          'hasSubCategories': subCategories.isNotEmpty,
          'subCategories': subCategories,
        };
      }));

      setState(() {
        categories = categoryWithSubCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> handleCategorySelection(
      String categoryId, String categoryName, bool hasSubCategories) async {
    if (hasSubCategories) {
      ref.read(sellProvider.notifier).setCategory(categoryName, categoryId);
      context.pushRoute(SubcategorySelectedRoute(categoryId: categoryId));
    } else {
      ref.read(sellProvider.notifier).setCategory(categoryName, categoryId);
      context.maybePop();
    }
  }

  Future<void> checkSubCategories(String categoryId) async {
    try {
      final sellNotifier = ref.read(sellProvider.notifier);
      final subCategories = await sellNotifier.fetchSubCategories(categoryId);
      if (subCategories.isNotEmpty) {
        // ignore: use_build_context_synchronously
        context.pushRoute(SubcategorySelectedRoute(categoryId: categoryId));
      } else {
        final categoryName =
            categories.firstWhere((cat) => cat['id'] == categoryId)['name']!;
        sellNotifier.setCategory(categoryName, categoryId);
        // ignore: use_build_context_synchronously
        context.maybePop();
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        label: 'category'.tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Style.mainColor,
              ))
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : categories.isEmpty
                    ? const Center(child: Text('No categories available'))
                    : Column(
                        children: categories.map((category) {
                          return CustomMenuItem(
                            label: tr(category['name']),
                            onTap: () {
                              handleCategorySelection(
                                category['id']!,
                                category['name']!,
                                category['hasSubCategories'],
                              );
                            },
                            showBorders: const {
                              'top': false,
                              'bottom': true,
                            },
                            suffix: category['hasSubCategories']
                                ? Icon(
                                    Remix.arrow_right_s_line,
                                    color: Style.hintColor,
                                    size: 24.r,
                                  )
                                : Container(),
                          );
                        }).toList(),
                      ),
      ),
    );
  }
}

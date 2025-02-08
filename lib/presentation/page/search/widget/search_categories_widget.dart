import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';

class SearchCategoriesWidget extends ConsumerStatefulWidget {
  const SearchCategoriesWidget({super.key});

  @override
  ConsumerState<SearchCategoriesWidget> createState() =>
      _SearchCategoriesWidgetState();
}

class _SearchCategoriesWidgetState
    extends ConsumerState<SearchCategoriesWidget> {
  List<Map<String, String>> categories = [];
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
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: Style.mainColor,
      ));
    } else {
      if (errorMessage != null) {
        return Center(child: Text(errorMessage!));
      } else {
        if (categories.isEmpty) {
          return const Center(child: Text('No categories available'));
        } else {
          return Column(
            children: categories.map((category) {
              return CustomMenuItem(
                label: category['name']!.tr(),
                onTap: () {},
                showBorders: const {
                  'top': false,
                  'bottom': true,
                },
              );
            }).toList(),
          );
        }
      }
    }
  }
}

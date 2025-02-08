import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/components/outline_bordered_text_field.dart';

@RoutePage()
class PriceSelectedPage extends ConsumerStatefulWidget {
  const PriceSelectedPage({super.key});

  @override
  ConsumerState<PriceSelectedPage> createState() => _PriceSelectedPageState();
}

class _PriceSelectedPageState extends ConsumerState<PriceSelectedPage> {
  final TextEditingController priceController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    priceController.addListener(onPriceChanged);
  }

  @override
  void dispose() {
    priceController.removeListener(onPriceChanged);
    priceController.dispose();
    super.dispose();
  }

  void onPriceChanged() {
    String text = priceController.text;
    if (text.isNotEmpty && !text.startsWith('₺')) {
      priceController.value = priceController.value.copyWith(
        text: '₺$text',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final sellState = ref.watch(sellProvider);
    // final sellEvent = ref.read(sellProvider.notifier);

    void updatePrice(String text) {
      final cleanText = text.replaceAll('₺', '').replaceAll(',', '');
      final price = int.tryParse(cleanText) ?? 0;

      ref.read(sellProvider.notifier).setPrice(price);
    }

    return Scaffold(
      appBar: CustomAppBar(label: 'price'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            OutlinedBorderTextField(
              label: 'price'.tr(),
              minLines: 1,
              textController: priceController,
              maxLines: null,
              onChanged: updatePrice,
              descriptionText: errorMessage ?? '',
            ),
            CustomButton(
                title: 'done'.tr(),
                onPressed: () async {
                  context.maybePop();
                })
          ],
        ),
      ),
    );
  }
}

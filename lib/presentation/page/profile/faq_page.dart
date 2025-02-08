import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final List<Map<String, String>> faqList = List.generate(
    10,
    (index) => {
      'question': 'faq_question_${index + 1}'.tr(),
      'answer': 'faq_answer_${index + 1}'.tr(),
    },
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: CustomAppBar(label: 'faq'.tr()),
      body: ListView.separated(
        itemCount: faqList.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Style.bgGrey,
        ),
        itemBuilder: (context, index) {
          return Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              minTileHeight: size.height * 0.07,
              backgroundColor: Style.white,
              collapsedBackgroundColor: Style.white,
              iconColor: Style.hintColor,
              collapsedIconColor: Style.hintColor,
              title: Text(
                faqList[index]['question']!,
                style: AppTextStyle.textStyle
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    faqList[index]['answer']!,
                    style: AppTextStyle.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Style.hintColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

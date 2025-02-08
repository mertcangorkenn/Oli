import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class ConditionSelectedPage extends ConsumerStatefulWidget {
  const ConditionSelectedPage({super.key});

  @override
  ConsumerState<ConditionSelectedPage> createState() =>
      _ConditionSelectedPageState();
}

class _ConditionSelectedPageState extends ConsumerState<ConditionSelectedPage> {
  List<Map<String, dynamic>> conditions = [
    {
      'id': 'newtags',
      'name': 'newwithtags'.tr(),
      'description': 'newwithtagsdesc'.tr()
    },
    {
      'id': 'new',
      'name': 'newwithouttags'.tr(),
      'description': 'newwithouttagsdesc'.tr()
    },
    {
      'id': 'verygood',
      'name': 'verygood'.tr(),
      'description': 'verygooddesc'.tr()
    },
    {'id': 'good', 'name': 'good'.tr(), 'description': 'gooddesc'.tr()},
    {
      'id': 'satisfactory',
      'name': 'satisfactory'.tr(),
      'description': 'satisfactorydesc'.tr()
    },
  ];

  bool isLoading = false;
  String? errorMessage;

  Future<void> handleConditionSelection(String condition) async {
    ref.read(sellProvider.notifier).setCondition(condition, condition);
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final sellState = ref.watch(sellProvider);
    return Scaffold(
      appBar: CustomAppBar(label: 'condition'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Style.mainColor,
              ))
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : conditions.isEmpty
                    ? const Center(child: Text('No condition available'))
                    : SingleChildScrollView(
                        child: Column(
                          children: conditions.map((condition) {
                            final isSelected =
                                sellState.conditionId == condition['id'];

                            return InkWell(
                              onTap: () {
                                handleConditionSelection(condition['id']);
                              },
                              child: Container(
                                width: size.width,
                                decoration: const BoxDecoration(
                                  color: Style.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Style.bgGrey)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              tr(condition['name']),
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                                color: Style.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              tr(condition['description']),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Style.hintColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: isSelected
                                            ? Text(
                                                'selected'.tr(),
                                                style: const TextStyle(
                                                  color: Style.mainColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
      ),
    );
  }
}


  // return CustomMenuItem(
  //                             label: tr(condition['name']),
  //                             description: tr(condition['description'] ?? ''),
  //                             onTap: () {
  //                               handleConditionSelection(
  //                                   condition['name'], condition['id']);
  //                             },
  //                             suffix: isSelected
  //                                 ? Text(
  //                                     'selected'.tr(),
  //                                     style: const TextStyle(
  //                                       color: Style.mainColor,
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   )
  //                                 : Container(),
  //                             showBorders: const {
  //                               'top': false,
  //                               'bottom': true,
  //                             },
  //                           );
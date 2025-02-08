// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/sell/sell_provider.dart';
import 'package:listing/infrastructure/service/app_helpers.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/components/full_screen_image_viewer.dart';
import 'package:listing/presentation/components/outline_bordered_text_field.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/page/sell/widget/loading_overlay.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class SellPage extends ConsumerStatefulWidget {
  const SellPage({super.key});

  @override
  ConsumerState<SellPage> createState() => _SellPageState();
}

class _SellPageState extends ConsumerState<SellPage> {
  List<String> imagePaths = [];

  void openImageViewer(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenImageViewer(
          imagePath: imagePath,
          isLocal: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final sellState = ref.watch(sellProvider);
    final sellEvent = ref.read(sellProvider.notifier);
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('sell'.tr(),
            style: GoogleFonts.lato(fontSize: 20, color: Style.black)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Style.black.withOpacity(0.2), height: 1)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: size.height * 0.25,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Style.white,
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: Style.black.withOpacity(0.2)))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            'photoslimit'.tr(),
                            style: GoogleFonts.lato(
                                color: Style.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          10.verticalSpace,
                          Expanded(
                              child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sellState.imagePaths.length +
                                (sellState.imagePaths.length < 20 ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == sellState.imagePaths.length) {
                                return GestureDetector(
                                  onTap: () => sellEvent.selectImage(),
                                  child: Container(
                                    width: size.width * 0.25,
                                    height: size.height * 0.2,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Style.black.withOpacity(0.2),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Remix.image_add_line,
                                        color: Style.grey,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () => openImageViewer(
                                      sellState.imagePaths[index]),
                                  child: Stack(children: [
                                    Container(
                                      width: size.width * 0.25,
                                      height: size.height * 0.2,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              sellState.imagePaths[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: size.height * 0.015,
                                        top: size.height * 0.005,
                                        child: GestureDetector(
                                          onTap: () =>
                                              sellEvent.deleteImage(index),
                                          child: Container(
                                            height: size.height * 0.025,
                                            width: size.height * 0.025,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Remix.close_line,
                                                color: Colors.white,
                                                size: size.height * 0.025,
                                              ),
                                            ),
                                          ),
                                        ))
                                  ]),
                                );
                              }
                            },
                          )),
                          5.verticalSpace,
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${sellState.imagePaths.length}/20',
                              style: GoogleFonts.lato(
                                color: Style.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                10.verticalSpace,
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Style.white,
                        border: Border.all(
                            width: 1, color: Style.black.withOpacity(0.2))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: OutlinedBorderTextField(
                        label: 'title'.tr(),
                        minLines: 1,
                        maxLines: null,
                        onChanged: sellEvent.setTitle,
                        hint: 'egtitle'.tr(),
                      ),
                    )),
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Style.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: Style.black.withOpacity(0.2))),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: OutlinedBorderTextField(
                        label: 'describe'.tr(),
                        hint: 'egdescribe'.tr(),
                        minLines: 2,
                        onChanged: sellEvent.setDescription,
                        maxLines: null,
                      ),
                    )),
                10.verticalSpace,
                CustomMenuItem(
                  label: 'category'.tr(),
                  onTap: () async {
                    if (sellState.category != null) {
                      sellEvent.clearCategories();
                      context.pushRoute(const CategorySelectedRoute());
                    } else {
                      context.pushRoute(const CategorySelectedRoute());
                    }
                  },
                  other: sellState.category != null
                      ? Text.rich(
                          overflow: TextOverflow.ellipsis,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: sellState.category!.tr(),
                                style: GoogleFonts.lato(
                                    color: Style.grey, fontSize: 16),
                              ),
                              if (sellState.subcategory != null)
                                TextSpan(
                                  text: ' - ',
                                  style: GoogleFonts.lato(
                                      color: Style.grey, fontSize: 16),
                                ),
                              if (sellState.subcategory != null)
                                TextSpan(
                                  text: sellState.subcategory!.tr(),
                                  style: GoogleFonts.lato(
                                      color: Style.grey, fontSize: 16),
                                ),
                            ],
                          ),
                        )
                      : null,
                  showBorders: const {
                    'top': true,
                    'bottom': true,
                  },
                ),
                CustomMenuItem(
                  label: 'brand'.tr(),
                  onTap: () {
                    context.pushRoute(const BrandSelectedRoute());
                  },
                  other: sellState.brand != null
                      ? Text(
                          sellState.brand.toString(),
                          style:
                              GoogleFonts.lato(color: Style.grey, fontSize: 16),
                        )
                      : null,
                  showBorders: const {
                    'top': false,
                    'bottom': true,
                  },
                ),
                CustomMenuItem(
                  label: 'sizes'.tr(),
                  onTap: () {
                    context.pushRoute(const SizeSelectedRoute());
                  },
                  other: sellState.size != null
                      ? Text(
                          sellState.size.toString(),
                          style:
                              GoogleFonts.lato(color: Style.grey, fontSize: 16),
                        )
                      : null,
                  showBorders: const {
                    'top': false,
                    'bottom': true,
                  },
                ),
                CustomMenuItem(
                  label: 'colours'.tr(),
                  onTap: () {
                    context.pushRoute(const ColorSelectedRoute());
                  },
                  other: sellState.color != null
                      ? Text(
                          tr(sellState.color.toString()),
                          style:
                              GoogleFonts.lato(color: Style.grey, fontSize: 16),
                        )
                      : null,
                  showBorders: const {
                    'top': false,
                    'bottom': true,
                  },
                ),
                CustomMenuItem(
                  label: 'condition'.tr(),
                  onTap: () {
                    context.pushRoute(const ConditionSelectedRoute());
                  },
                  other: sellState.condition != null
                      ? Text(
                          tr(sellState.condition.toString()),
                          style:
                              GoogleFonts.lato(color: Style.grey, fontSize: 16),
                        )
                      : null,
                  showBorders: const {
                    'top': false,
                    'bottom': true,
                  },
                ),
                CustomMenuItem(
                  label: 'material'.tr(),
                  onTap: () {
                    context.pushRoute(const MaterialSelectedRoute());
                  },
                  other: sellState.material != null
                      ? Text(
                          tr(sellState.material.toString()),
                          style:
                              GoogleFonts.lato(color: Style.grey, fontSize: 16),
                        )
                      : null,
                  showBorders: const {
                    'top': false,
                    'bottom': true,
                  },
                ),
                10.verticalSpace,
                CustomMenuItem(
                  label: 'price'.tr(),
                  onTap: () {
                    context.pushRoute(const PriceSelectedRoute());
                  },
                  other: sellState.price != null
                      ? Text(
                          '₺${sellState.price.toString()}',
                          style:
                              GoogleFonts.lato(color: Style.grey, fontSize: 16),
                        )
                      : null,
                  showBorders: const {
                    'top': true,
                    'bottom': true,
                  },
                ),
                20.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomButton(
                    title: 'upload'.tr(),
                    onPressed: () async {
                      if (sellEvent.validateForm()) {
                        try {
                          await sellEvent.uploadProduct();
                          sellEvent.clearAll();
                          await AppHelpers.showCheckTopSnackBarDone(
                              context, 'productuploadedsuccessfully'.tr());
                        } catch (e) {
                          AppHelpers.showCheckTopSnackBar(
                              context, '${'erroruploadingproduct'.tr()} $e');
                        }
                      } else {
                        AppHelpers.showCheckTopSnackBarInfo(
                            context, 'pleasefillinallrequiredfields'.tr());
                      }
                    },
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
          LoadingOverlay(isLoading: sellState.isLoading),
        ],
      ),
    );
  }
}

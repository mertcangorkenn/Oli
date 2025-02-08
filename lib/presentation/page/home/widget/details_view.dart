import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:listing/infrastructure/service/app_constants.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/home/home_provider.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/presentation/components/custom_button.dart';
import 'package:listing/presentation/components/custom_line_button.dart';
import 'package:listing/presentation/page/home/widget/image_carousel.dart';
import 'package:listing/presentation/page/profile/widgets/custom_menu_item.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class DetailsViewPage extends ConsumerStatefulWidget {
  final String itemId;
  final String userId;

  const DetailsViewPage(this.userId, {super.key, required this.itemId});

  @override
  ConsumerState<DetailsViewPage> createState() => _DetailsViewPageState();
}

class _DetailsViewPageState extends ConsumerState<DetailsViewPage> {
  late PageController pageController;
  int currentPage = 0;
  bool isExpanded = false; // daha fazla göster

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).fetchItemDetails(widget.itemId);
      ref.read(homeProvider.notifier).fetchUserProfile(widget.userId);
    });
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final homeState = ref.watch(homeProvider);
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Style.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Style.transparent,
        elevation: 0,
        backgroundColor: Style.transparent,
        leading: IconButton.filled(
          onPressed: () {
            context.maybePop();
          },
          icon: const Icon(Remix.arrow_left_line, size: 24, color: Style.white),
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(Style.black.withOpacity(0.5))),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                if (profileState.favorites.contains(homeState.id)) {
                  ref
                      .read(profileProvider.notifier)
                      .removeFavorite(homeState.id!);
                } else {
                  ref.read(profileProvider.notifier).addFavorite(homeState.id!);
                }
              });
            },
            icon: Icon(
              profileState.favorites.contains(homeState.id)
                  ? Remix.heart_3_fill
                  : Remix.heart_3_line,
              size: 24,
              // ignore: unrelated_type_equality_checks
              color: profileState.favorites.contains(homeState.id)
                  ? Style.mainColor
                  : Style.white,
            ),
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(Style.black.withOpacity(0.5)),
            ),
          ),
          IconButton.filled(
            onPressed: () {
              Share.share("${AppConstants.appName} ${'sharetext'.tr()}",
                  subject: '${AppConstants.appName} - ${'handmade'.tr()}');
            },
            icon: const Icon(Remix.share_2_line, size: 24, color: Style.white),
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Style.black.withOpacity(0.5))),
          ),
        ],
      ),
      body: homeState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Style.mainColor))
          : homeState.errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                  homeState.errorMessage,
                  style: GoogleFonts.lato(),
                ))
              : homeState.imagePaths.isEmpty
                  ? Center(child: Text('itemnotfound'.tr()))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                              height: size.height * 0.6,
                              child: ImageCarousel(
                                  imageUrls: homeState.imagePaths)),
                          Container(
                            height: size.height * 0.1,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Style.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Style.black.withOpacity(0.2)))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage:
                                            homeState.avatar!.isNotEmpty
                                                ? CachedNetworkImageProvider(
                                                    homeState.avatar!)
                                                : null,
                                        child: homeState.avatar!.isEmpty
                                            ? Text(
                                                homeState.username!.isNotEmpty
                                                    ? homeState.username![0]
                                                        .toUpperCase()
                                                    : '',
                                                style: GoogleFonts.lato(
                                                    fontSize: 20,
                                                    color: Style.black),
                                              )
                                            : null,
                                      ),
                                      10.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(homeState.fullname!,
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  color: Style.black)),
                                          Text('@${homeState.username!}',
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  color: Style.black)),
                                        ],
                                      ),
                                      const Spacer(),
                                      CustomLineButton(
                                          title: 'follow'.tr(),
                                          weight: size.width * 0.1,
                                          height: size.width * 0.1,
                                          onPressed: () {}),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: size.height * 0.1,
                            width: size.width,
                            decoration: const BoxDecoration(
                                color: Style.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Style.bgGrey))),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        homeState.title!,
                                        style: GoogleFonts.lato(
                                            fontSize: 20,
                                            color: Style.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            homeState.size!,
                                            style: GoogleFonts.lato(
                                              fontSize: 18,
                                              color: Style.grey,
                                            ),
                                          ),
                                          5.horizontalSpace,
                                          Text(
                                            '•',
                                            style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Style.grey),
                                          ),
                                          5.horizontalSpace,
                                          Text(
                                            tr(homeState.condition!),
                                            style: GoogleFonts.lato(
                                              fontSize: 18,
                                              color: Style.grey,
                                            ),
                                          ),
                                          5.horizontalSpace,
                                          Text(
                                            '•',
                                            style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Style.grey),
                                          ),
                                          5.horizontalSpace,
                                          Text(
                                            homeState.brand!,
                                            style: GoogleFonts.lato(
                                              fontSize: 18,
                                              color: Style.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${homeState.price.toString()} TL',
                                    style: GoogleFonts.lato(
                                      fontSize: 24,
                                      color: Style.mainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // açıklama
                          10.verticalSpace,
                          Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Style.white,
                              border: Border.all(width: 1, color: Style.bgGrey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'describe'.tr(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                        fontSize: 16, color: Style.hintColor),
                                  ),
                                  10.verticalSpace,
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: isExpanded
                                          ? homeState.describe
                                          : (homeState.describe!.length > 300
                                              ? '${homeState.describe!.substring(0, 300)}...'
                                              : homeState.describe),
                                      style: GoogleFonts.lato(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (homeState.describe!.length > 300)
                                      TextSpan(
                                        text: isExpanded
                                            ? ' ${'showLess'.tr()}'
                                            : ' ${'showMore'.tr()}',
                                        style: GoogleFonts.lato(
                                          color: Style.mainColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              isExpanded = !isExpanded;
                                            });
                                          },
                                      ),
                                  ]))
                                ],
                              ),
                            ),
                          ),
                          // ürün bilgileri
                          CustomMenuItem(
                            label: 'category'.tr(),
                            onTap: () {},
                            other: Text(
                                '${tr(homeState.category!)} - ${tr(homeState.subcategory!)}',
                                style: GoogleFonts.lato(
                                    color: Style.grey, fontSize: 16)),
                            showBorders: const {'top': false, 'bottom': true},
                          ),
                          CustomMenuItem(
                            label: 'sizes'.tr(),
                            onTap: () {},
                            other: Text(tr(homeState.size!),
                                style: GoogleFonts.lato(
                                    color: Style.grey, fontSize: 16)),
                            showBorders: const {'top': false, 'bottom': true},
                          ),
                          CustomMenuItem(
                            label: 'condition'.tr(),
                            onTap: () {},
                            other: Text(tr(homeState.condition!),
                                style: GoogleFonts.lato(
                                    color: Style.grey, fontSize: 16)),
                            showBorders: const {'top': false, 'bottom': true},
                          ),
                          CustomMenuItem(
                            label: 'material'.tr(),
                            onTap: () {},
                            suffix: Text(tr(homeState.material!),
                                style: GoogleFonts.lato(
                                    color: Style.grey, fontSize: 16)),
                            showBorders: const {'top': false, 'bottom': true},
                          ),
                          CustomMenuItem(
                            label: 'colours'.tr(),
                            onTap: () {},
                            suffix: Text(tr(homeState.color!),
                                style: GoogleFonts.lato(
                                    color: Style.grey, fontSize: 16)),
                            showBorders: const {'top': false, 'bottom': true},
                          ),
                          CustomMenuItem(
                            label: 'uploadeddate'.tr(),
                            onTap: () {},
                            suffix: Text(homeState.createdAt.toString(),
                                style: GoogleFonts.lato(
                                    color: Style.grey, fontSize: 16)),
                            showBorders: const {'top': false, 'bottom': true},
                          ),
                          10.verticalSpace,
                          Container(
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Style.white,
                                border:
                                    Border.all(width: 1, color: Style.bgGrey)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton.filled(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Remix.alarm_warning_line,
                                      color: Style.mainColor,
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(Style
                                                .mainColor
                                                .withOpacity(0.5))),
                                  ),
                                  10.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('buyerprotection'.tr(),
                                            style: GoogleFonts.lato(
                                                color: Style.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                        Text('buyerprotectiontext'.tr(),
                                            maxLines: 5,
                                            style: GoogleFonts.lato(
                                                color: Style.grey,
                                                fontSize: 14)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          10.verticalSpace,
                        ],
                      ),
                    ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Style.bgGrey,
              width: 1,
            ),
          ),
        ),
        child: BottomAppBar(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomLineButton(
                title: 'makeanoffer'.tr(),
                onPressed: () {},
                height: size.width * 0.12,
                weight: size.width * 0.44,
              ),
              10.horizontalSpace,
              CustomButton(
                title: 'sendmessage'.tr(),
                onPressed: () {},
                height: size.width * 0.12,
                weight: size.width * 0.44,
              )
            ],
          ),
        ),
      ),
    );
  }
}

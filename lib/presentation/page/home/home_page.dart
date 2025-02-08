import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/home/home_provider.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/presentation/page/home/widget/all_view.dart';
import 'package:listing/presentation/page/home/widget/only_view.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getProfileDetails();
      ref.read(homeProvider.notifier).fetchListing();
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
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final profileState = ref.watch(profileProvider);
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            context.pushRoute(const SearchRoute());
          },
          overlayColor: WidgetStateProperty.all(Style.transparent),
          child: Container(
            height: size.height * 0.05,
            width: size.width,
            decoration: BoxDecoration(
              color: Style.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Remix.search_line, size: 18, color: Style.grey),
                  10.horizontalSpace,
                  Text(
                    'searchText'.tr(),
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Style.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                context.pushRoute(const NotificationRoute());
              },
              overlayColor: WidgetStateProperty.all(Style.transparent),
              child: const Icon(
                Remix.notification_2_line,
                size: 20,
                color: Style.grey,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: tabController,
            tabs: [
              Tab(text: 'only'.tr()),
              Tab(text: 'all'.tr()),
            ],
            overlayColor: WidgetStateProperty.all(Style.transparent),
            indicatorColor: Style.mainColor,
            labelColor: Style.mainColor,
            unselectedLabelColor: Style.grey,
            dividerColor: Style.bgGrey,
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          OnlyView(homeState: homeState),
          AllView(
            homeState: homeState,
            profileState: profileState,
          ),
        ],
      ),
    );
  }
}

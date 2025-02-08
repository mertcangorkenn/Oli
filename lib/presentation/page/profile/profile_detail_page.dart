import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/presentation/page/home/widget/image_carousel.dart';
import 'package:listing/presentation/page/profile/widgets/profile_header_widget.dart';

import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class ProfileDetailPage extends ConsumerStatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  ConsumerState<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends ConsumerState<ProfileDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(profileProvider.notifier)
          .fetchUserItems(firebaseAuth.currentUser!.uid);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.width * 0.1,
          leading: IconButton(
              onPressed: () {
                context.maybePop();
              },
              icon: const Icon(Remix.arrow_left_line,
                  size: 24, color: Style.black)),
          centerTitle: true,
          backgroundColor: Style.transparent,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Remix.more_line, size: 24, color: Style.black))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ProfileHeaderWidget(
                  avatar: state.avatar,
                  username: state.username,
                  fullname: state.fullname!,
                  bio: state.bio!,
                  tabController: tabController,
                ),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = state.userItems[index];
                    final imageUrls = (item['images'] as List<dynamic>)
                        .map((e) => e as String)
                        .toList();
                    final username = item['username'] as String;
                    // final itemId = item['id'] as String;

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Style.backgroundColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: state.avatar!.isNotEmpty
                                      ? NetworkImage(state.avatar!)
                                      : null,
                                  child: state.avatar!.isEmpty
                                      ? Text(
                                          username.isNotEmpty
                                              ? username[0].toUpperCase()
                                              : '',
                                          style: GoogleFonts.lato(
                                              fontSize: 20, color: Style.black),
                                        )
                                      : null,
                                ),
                                10.horizontalSpace,
                                Text(
                                  state.username,
                                  style: GoogleFonts.lato(
                                      fontSize: 14, color: Style.grey),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: imageUrls.isEmpty
                                ? Center(
                                    child: Text(
                                    'noimagesavailable'.tr(),
                                    style: GoogleFonts.lato(),
                                  ))
                                : ImageCarousel(imageUrls: imageUrls),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item['title'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Style.grey,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['size'],
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Style.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  item['brand'],
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Style.grey,
                                  ),
                                ),
                                Text(
                                  '${item['price']} TL',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Style.mainColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: state.userItems.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.56,
                ),
              ),
            ],
          ),
        ));
  }
}

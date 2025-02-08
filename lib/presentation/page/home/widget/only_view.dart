import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/home/home_state.dart';
import 'package:listing/app/profile/profile_provider.dart';
import 'package:listing/presentation/page/home/widget/image_carousel.dart';
import 'package:listing/presentation/routes/app_router.gr.dart';
import 'package:listing/presentation/theme/app_style.dart';

class OnlyView extends ConsumerWidget {
  final HomeState homeState;

  const OnlyView({
    super.key,
    required this.homeState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileEvent = ref.read(profileProvider.notifier);
    if (homeState.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Style.mainColor));
    }
    if (homeState.errorMessage.isNotEmpty) {
      return Center(child: Text(homeState.errorMessage));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.56,
        ),
        itemCount: homeState.items.length,
        itemBuilder: (context, index) {
          final item = homeState.items[index];
          final imageUrls = item['images'] as List<String>;
          final username = item['username'] as String;
          final avatar = item['avatar'] as String;
          final userId = item['userid'] as String;
          final itemId = item['id'] as String;

          return InkWell(
            onTap: () {
              context
                  .pushRoute(DetailsViewRoute(itemId: itemId, userId: userId));
            },
            overlayColor: WidgetStateProperty.all(Style.transparent),
            child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: avatar.isNotEmpty
                              ? CachedNetworkImageProvider(avatar)
                              : null,
                          child: avatar.isEmpty
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
                          username,
                          style:
                              GoogleFonts.lato(fontSize: 14, color: Style.grey),
                        ),
                        const Spacer(),
                        FutureBuilder<bool>(
                            future: profileEvent.isFavorite(itemId),
                            builder: (context, snapshot) {
                              final isFavorite = snapshot.data ?? false;
                              return InkWell(
                                onTap: () async {
                                  if (isFavorite) {
                                    await profileEvent.removeFavorite(itemId);
                                  } else {
                                    await profileEvent.addFavorite(itemId);
                                  }
                                },
                                overlayColor:
                                    WidgetStateProperty.all(Style.transparent),
                                child: Icon(
                                  isFavorite
                                      ? Remix.heart_3_fill
                                      : Remix.heart_3_line,
                                  size: 24,
                                  color: isFavorite
                                      ? Style.mainColor
                                      : Style.hintColor,
                                ),
                              );
                            })
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
          );
        },
      ),
    );
  }
}

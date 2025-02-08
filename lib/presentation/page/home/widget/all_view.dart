import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/app/home/home_state.dart';
import 'package:listing/app/profile/profile_state.dart';
import 'package:listing/presentation/page/home/widget/image_carousel.dart';
import 'package:listing/presentation/theme/app_style.dart';

class AllView extends StatelessWidget {
  final HomeState homeState;
  final ProfileState profileState;

  const AllView({
    super.key,
    required this.homeState,
    required this.profileState,
  });

  @override
  Widget build(BuildContext context) {
    if (homeState.isLoading) {
      return const Center(child: CircularProgressIndicator());
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
          childAspectRatio: 0.60,
        ),
        itemCount: homeState.items.length,
        itemBuilder: (context, index) {
          final item = homeState.items[index];
          final dynamicImageUrls = item['images'] as List<dynamic>? ?? [];
          final imageUrls =
              dynamicImageUrls.map((url) => url.toString()).toList();

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Style.backgroundColor,
              ),
              borderRadius: BorderRadius.circular(8),
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
                        radius: 12.r,
                        child: profileState.avatar != null &&
                                profileState.avatar!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  profileState.avatar!,
                                  fit: BoxFit.cover,
                                  width: 24.r,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Text(
                                    profileState.username.isNotEmpty
                                        ? profileState.username[0].toUpperCase()
                                        : '',
                                    style: GoogleFonts.lato(
                                        fontSize: 20, color: Style.black),
                                  ),
                                ),
                              )
                            : Text(
                                profileState.username.isNotEmpty
                                    ? profileState.username[0].toUpperCase()
                                    : '',
                                style: GoogleFonts.lato(
                                    fontSize: 20, color: Style.black),
                              ),
                      ),
                      10.horizontalSpace,
                      Text(
                        profileState.username,
                        style:
                            GoogleFonts.lato(fontSize: 14, color: Style.grey),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: imageUrls.isEmpty
                      ? Center(child: Text('noimagesavailable'.tr()))
                      : ImageCarousel(imageUrls: imageUrls),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        '${item['price']} TL',
                        style: GoogleFonts.lato(
                          fontSize: 18,
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
      ),
    );
  }
}

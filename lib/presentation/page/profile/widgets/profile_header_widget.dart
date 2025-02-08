import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String? avatar;
  final String username;
  final String fullname;
  final String bio;
  final TabController tabController;

  const ProfileHeaderWidget(
      {super.key,
      this.avatar,
      required this.username,
      required this.fullname,
      required this.bio,
      required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50.r,
            child: avatar != null && avatar!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      avatar!,
                      fit: BoxFit.cover,
                      width: 100.r,
                      errorBuilder: (context, error, stackTrace) => Text(
                        username.isNotEmpty ? username[0].toUpperCase() : '',
                        style:
                            GoogleFonts.lato(fontSize: 20, color: Style.black),
                      ),
                    ),
                  )
                : Text(
                    username.isNotEmpty ? username[0].toUpperCase() : '',
                    style: GoogleFonts.lato(fontSize: 20, color: Style.black),
                  ),
          ),
          10.verticalSpace,
          Text(
            fullname,
            style: GoogleFonts.lato(
                fontSize: 24, fontWeight: FontWeight.bold, color: Style.black),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '@$username',
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Style.black),
              ),
              5.horizontalSpace,
              Text(
                '•',
                style: GoogleFonts.lato(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Style.grey),
              ),
              5.horizontalSpace,
              Text(
                '0 ${'follows'.tr()}',
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Style.black),
              ),
              5.horizontalSpace,
              Text(
                '•',
                style: GoogleFonts.lato(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Style.grey),
              ),
              5.horizontalSpace,
              Text(
                '0 ${'followyou'.tr()}',
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Style.black),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            bio,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                fontSize: 16, fontWeight: FontWeight.w500, color: Style.black),
          ),
          TabBar(
            controller: tabController,
            tabs: [
              Tab(text: 'myitems'.tr()),
            ],
            overlayColor: WidgetStateProperty.all(Style.transparent),
            indicatorColor: Style.mainColor,
            labelColor: Style.mainColor,
            unselectedLabelColor: Style.grey,
            dividerColor: Style.backgroundColor,
          ),
          10.verticalSpace,
        ],
      ),
    );
  }
}

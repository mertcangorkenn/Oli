import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:remixicon/remixicon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final List<Widget>? actions;
  final VoidCallback? onPressed;
  const CustomAppBar(
      {super.key, required this.label, this.actions, this.onPressed});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
          onPressed: onPressed ??
              () {
                context.maybePop();
              },
          icon:
              const Icon(Remix.arrow_left_line, size: 24, color: Style.black)),
      title: Text(
        label,
        style: GoogleFonts.lato(fontSize: 20, color: Style.black),
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Style.black.withOpacity(0.2), height: 1),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'inbox'.tr(),
          style: GoogleFonts.lato(
              fontSize: 20, color: Style.black, fontWeight: FontWeight.normal),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Remix.send_plane_fill,
                size: 24,
                color: Style.mainColor,
              ))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Style.black.withOpacity(0.2), height: 1),
        ),
      ),
      body: Center(
        child: Text(
          'mesajlar gelecek',
          style: GoogleFonts.lato(),
        ),
      ),
    );
  }
}

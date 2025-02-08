import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:listing/presentation/theme/app_style.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:remixicon/remixicon.dart';

class FullscreenImageViewer extends StatelessWidget {
  final String imagePath;
  final bool isLocal;

  const FullscreenImageViewer({
    super.key,
    required this.imagePath,
    required this.isLocal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Style.transparent,
        actions: [
          IconButton(
            onPressed: () {
              context.maybePop();
            },
            icon: const Icon(
              Remix.close_line,
              color: Style.white,
              size: 24,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: PhotoView(
          imageProvider: isLocal
              ? FileImage(File(imagePath))
              : CachedNetworkImageProvider(imagePath),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/components/custom_app_bar.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  String? url;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          label: 'privacypolicy'.tr(),
        ),
        body: FutureBuilder<DocumentSnapshot?>(
            future: FirebaseFirestore.instance
                .collection('settings')
                .doc('privacy')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Style.mainColor,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.lato(fontSize: 16, color: Style.black),
                  ),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                    child: Text(
                  'notfound'.tr(),
                  style: GoogleFonts.lato(fontSize: 16, color: Style.black),
                ));
              }
              final String url = snapshot.data!.get('url') as String;
              return InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(url)),
              );
            }));
  }
}

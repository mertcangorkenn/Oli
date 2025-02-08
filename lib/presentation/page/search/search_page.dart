import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listing/presentation/page/search/widget/search_categories_widget.dart';
import 'package:listing/presentation/page/search/widget/search_page_widget.dart';
import 'package:listing/presentation/theme/app_style.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    searchQuery = "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: SizedBox(
            height: size.height * 0.05,
            child: TextFormField(
              cursorColor: Style.grey,
              decoration: InputDecoration(
                filled: true,
                contentPadding:
                    REdgeInsets.symmetric(horizontal: 10, vertical: 8),
                fillColor: Style.backgroundColor,
                prefixIcon:
                    const Icon(Remix.search_line, color: Style.grey, size: 18),
                hintText: 'searchText'.tr(),
                hintStyle: GoogleFonts.lato(
                  fontSize: 16,
                  color: Style.grey,
                  fontWeight: FontWeight.normal,
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Style.black.withOpacity(0.2), height: 1),
          ),
        ),
        body: searchQuery.isEmpty
            ? const SearchCategoriesWidget()
            : const SearchPageWidget());
  }
}

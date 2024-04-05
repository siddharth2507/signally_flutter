import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/z_card.dart';
import '../../models_providers/app_provider.dart';

import '../../components/z_annoucement_card.dart';
import '../../components/z_news_card.dart';
import '../../constants/app_colors.dart';
import 'annoucements_page.dart';
import 'news_page.dart';

class HomePage2 extends StatefulWidget {
  HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final announcements = appProvider.announcements;
    final news = appProvider.newsAll;
    final announcementsFirst5 = announcements.length > 2 ? announcements.sublist(0, 2) : announcements;
    final newsFirst5 = news.length > 5 ? news.sublist(0, 5) : news;
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 16),
          _buildHeading(
              title: 'Announcements', onTap: () => Get.to(() => AnnoucementsPage(announcements: announcements), fullscreenDialog: true), showViewAll: announcements.length > 2),
          Column(children: [for (var post in announcementsFirst5) ZAnnoucementCard(announcement: post)]),
          SizedBox(height: 16),
          /* ---------------------------------- NEWS ---------------------------------- */
          if (news.length > 0) _buildHeading(title: 'News', onTap: () => Get.to(() => NewsPage(news: news), fullscreenDialog: true), showViewAll: true),
          Column(children: [for (var n in newsFirst5) ZNewsCard(news: n)]),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Container _buildHeading({required String title, required Function() onTap, bool showViewAll = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppCOLORS.yellow)),
          Spacer(),
          if (showViewAll)
            ZCard(
              margin: EdgeInsets.symmetric(),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text('View all'),
              borderRadiusColor: AppCOLORS.yellow,
              onTap: onTap,
            ),
        ],
      ),
    );
  }
}

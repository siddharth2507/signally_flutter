import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/z_card.dart';
import '../../models/post_aggr.dart';
import '../../models/video_lesson_aggr.dart';
import '../../models_providers/app_provider.dart';
import 'post_details_page.dart';
import 'posts_page.dart';
import 'videos_page.dart';
import '../../utils/z_format.dart';

import '../../components/z_image_display.dart';
import '../../constants/app_colors.dart';
import '../../utils/z_launch_url.dart';

class LearnPage extends StatefulWidget {
  LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final posts = appProvider.posts;
    final videos = appProvider.videoLessons;
    final postsFirst5 = posts.length > 5 ? posts.sublist(0, 5) : posts;
    final videosFirst5 = videos.length > 5 ? videos.sublist(0, 5) : videos;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: ListView(
        children: [
          SizedBox(height: 16),
          _buildHeading(title: 'Posts', onTap: () => Get.to(() => PostsPage(posts: posts), fullscreenDialog: true), length: posts.length),
          Column(children: [for (var post in postsFirst5) PostCard(post: post)]),
          SizedBox(height: 16),
          _buildHeading(title: 'Videos', onTap: () => Get.to(() => VideosPage(videos: videos), fullscreenDialog: true), length: videos.length),
          Column(children: [for (var video in videosFirst5) VideoCard(videoLesson: video)]),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Container _buildHeading({required String title, required Function() onTap, required int length}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 16),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppCOLORS.yellow)),
          Spacer(),
          if (length > 4)
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

class PostCard extends StatelessWidget {
  const PostCard({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return ZCard(
      borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
      onTap: () => Get.to(() => PostDetailsPage(post: post), transition: Transition.cupertino, fullscreenDialog: true),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          Hero(
            tag: post.id,
            child: ZImageDisplay(
              image: post.image,
              height: MediaQuery.of(context).size.width * .225,
              width: MediaQuery.of(context).size.width,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Text(post.title),
          ),
          SizedBox(height: 4),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Text(ZFormat.dateFormatSignal(post.postDate)),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({Key? key, required this.videoLesson}) : super(key: key);
  final VideoLesson videoLesson;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    return ZCard(
      onTap: () => ZLaunchUrl.launchUrl(videoLesson.link),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(),
      borderRadiusColor: isLightTheme ? appColorCardBorderLight : appColorCardBorderDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          ZImageDisplay(
            image: videoLesson.image,
            height: MediaQuery.of(context).size.width * .225,
            width: MediaQuery.of(context).size.width,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Text(videoLesson.title),
          ),
          SizedBox(height: 4),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Text(ZFormat.dateFormatSignal(videoLesson.timestampCreated)),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

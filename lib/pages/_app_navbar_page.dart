import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/models/auth_user.dart';
import 'package:signalbyt/models_providers/auth_provider.dart';
import 'package:signalbyt/pages/group_chat/chat_page_arguments.dart';
import 'package:signalbyt/utils/unityadsmediation.dart';
import 'package:signalbyt/utils/unityadsutils.dart';
import 'group_chat/group_chat_page.dart';
import 'learn/learn_page.dart';
import 'signals/signals_init_page.dart';

import '../../../models_providers/navbar_provider.dart';
import '../constants/app_colors.dart';
import 'home/home_page2.dart';
import 'user/my_account_page.dart';

class AppNavbarPage extends StatefulWidget {
  const AppNavbarPage({Key? key}) : super(key: key);

  @override
  _AppNavbarPageState createState() => _AppNavbarPageState();
}

class _AppNavbarPageState extends State<AppNavbarPage> {
  late PageController _pageController;

  @override
  void initState() {
    final appProvider = Provider.of<NavbarProvider>(context, listen: false);
    _pageController =
        PageController(initialPage: appProvider.selectedPageIndex);
    super.initState();
    UnityAdsServices.showInterstitial();

    UnityAdsServices.loadAds();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<NavbarProvider>(context, listen: false);
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final AuthUser? authUser = authProvider.authUser;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Community',style: TextStyle(color: AppCOLORS.cardDark),),
        // isExtended: true,
        icon: SvgPicture.asset('assets/svg/chat_bubble.svg', colorFilter: ColorFilter.mode(AppCOLORS.cardDark, BlendMode.srcIn), height: 20, width: 20),
        backgroundColor: appColorYellow,
        onPressed: () {
          if (authUser?.isAnonymous == false) {
            Get.to(GroupChatPage(),
                arguments: ChatPageArguments(
                    adminId: authUser!.id!,
                    mId: authUser.id!,
                    mName: authUser.name ?? '',
                    mImage: '',
                    groupId: '',
                    receiverUserToken: ''),
                // userLike: chatController.userMatch[index],
                fullscreenDialog: true,
                duration: Duration(milliseconds: 500));
          } else {
            showToastWidget(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
                margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 75),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    color: Color(0xFF5EEDA5)),
                child: Text("You need to Login",
                    style: TextStyle(color: Colors.black87)),
              ),
              context: context,
              animation: StyledToastAnimation.fadeScale,
              reverseAnimation: StyledToastAnimation.fade,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 4),
              curve: Curves.linearToEaseOut,
              reverseCurve: Curves.linear,
            );
          }
        },
      ),
      body: AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
          duration: const Duration(milliseconds: 300),
          child: pages.elementAt(appProvider.selectedPageIndex)),
      bottomNavigationBar: CustomNavigationBar(
        blurEffect: false,
        onTap: (v) {


          appProvider.selectedPageIndex = v;
          if (_pageController.hasClients)
            _pageController.animateToPage(v,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);

          UnityAdsServices.showInterstitial();
        },
        // iconSize: 20.0,
        selectedColor: Colors.white,
        strokeColor: Colors.white,
        backgroundColor: isLightTheme
            ? Colors.grey.shade300
            : Color(0xFF35383F).withOpacity(.8),
        borderRadius: Radius.circular(20.0),
        opacity: 1,
        elevation: 0,
        currentIndex: appProvider.selectedPageIndex,
        isFloating: true,
        items: [
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/home.svg',
                colorFilter: ColorFilter.mode(getIconColor(0), BlendMode.srcIn),
                height: getIconHeight(0),
                width: getIconHeight(0)),
            title: Text('Home',
                style: TextStyle(color: getIconColor(0), fontSize: 12)),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/learn.svg',
                colorFilter: ColorFilter.mode(getIconColor(1), BlendMode.srcIn),
                height: getIconHeight(1),
                width: getIconHeight(1)),
            title: Text('Learn',
                style: TextStyle(color: getIconColor(1), fontSize: 12)),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/go-long.svg',
                colorFilter: ColorFilter.mode(getIconColor(2), BlendMode.srcIn),
                height: getIconHeight(2),
                width: getIconHeight(2)),
            title: Text('Signals',
                style: TextStyle(color: getIconColor(2), fontSize: 12)),
          ),
          // CustomNavigationBarItem(
          //   icon: SvgPicture.asset('assets/svg/notification.svg',
          //       colorFilter: ColorFilter.mode(getIconColor(3), BlendMode.srcIn), height: getIconHeight(3), width: getIconHeight(3)),
          //   title: Text('Alerts', style: TextStyle(color: getIconColor(3), fontSize: 12)),
          // ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/user.svg',
                colorFilter: ColorFilter.mode(getIconColor(3), BlendMode.srcIn),
                height: getIconHeight(3),
                width: getIconHeight(3)),
            title: Text('Profile',
                style: TextStyle(color: getIconColor(3), fontSize: 12)),
          ),
        ],
      ),
    );
  }

  double getIconHeight(int index) {
    final appProvider = Provider.of<NavbarProvider>(context);
    final selectedIndex = appProvider.selectedPageIndex;
    return selectedIndex == index ? 24 : 20;
  }

  Color getIconColor(int index) {
    final appProvider = Provider.of<NavbarProvider>(context);
    final selectedIndex = appProvider.selectedPageIndex;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    Color color = isLightTheme ? Colors.black26 : Colors.white24;
    if (selectedIndex == index)
      return isLightTheme ? appColorBlue : appColorYellow;
    return color;
  }

/* ----------------------------- NOTE UserPages ----------------------------- */

  List<Widget> pages = [
    HomePage2(),
    LearnPage(),
    SignalsInitPage(type: 'long', key: ObjectKey('long')),
    // NotificationsPage(),
    MyAccountPage(),
  ];
}

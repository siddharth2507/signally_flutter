import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/pages/_app_navbar_page.dart';
import 'package:signalbyt/utils/unityadsmediation.dart';
import 'package:signalbyt/utils/unityadsutils.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:unity_mediation/unity_mediation.dart';

import '../../models_providers/app_provider.dart';
import '../../models_providers/auth_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    /*
    UnityMediation.loadInterstitialAd(
        adUnitId: UnityAdsUtils.interstitialAdUnitId,
        onComplete: (adUnitId) {
          UnityMediation.showInterstitialAd(
              adUnitId: UnityAdsUtils.interstitialAdUnitId);
          startNavigate();
          print('Interstitial Ad Load Complete $adUnitId');
        },
        onFailed: (adUnitId, error, message) {
          print('Interstitial Ad Load Failed $adUnitId: $error $message');
          startNavigate();
        });*/

    super.initState();
    // UnityAdsServices.initUnityads();
    UnityAds.load(
        placementId: UnityAdsServices.interstitialAdUnitId,
        onComplete: (placementId) {
          print('Load Complete $placementId');
          startNavigate();
        },
        onFailed: (placementId, error, message) {
          print('Load Failed $placementId: $error $message');
          startNavigate();
        });
  }

  startNavigate() {
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      await Provider.of<AuthProvider>(context, listen: false).init();
      Provider.of<AppProvider>(context, listen: false);
      await Future.delayed(Duration(milliseconds: 250));
      FlutterNativeSplash.remove();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

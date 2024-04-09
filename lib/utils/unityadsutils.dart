import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityAdsServices {
  static var gameID = '5591443';
  static var rewardedAdUnitId = 'Rewarded_Android';
  static var interstitialAdUnitId = 'Interstitial_Android';

  static initUnityads() async {
    UnityAds.init(
      // testMode: false,
      gameId: gameID,
      firebaseTestLabMode: FirebaseTestLabMode.disableAds,
      onComplete: () {
        loadAds();
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  static loadAds() {
    loadInterstitial();
    loadRewarded();
  }

  static void loadInterstitial() {
    UnityAds.load(
      placementId: interstitialAdUnitId,
      onComplete: (placementId) => print('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  static showInterstitial() {
    UnityAds.showVideoAd(
      placementId: interstitialAdUnitId,
      onStart: (placementId) => print('UnityAds Video Ad $placementId started'),
      onClick: (placementId) => print('UnityAds Video Ad $placementId click'),
      onSkipped: (placementId) =>
          print('UnityAds Video Ad $placementId skipped'),
      onComplete: (placementId) {
        loadInterstitial();
      },
      onFailed: (placementId, error, message) {
        loadInterstitial();
      },
    );
  }

  static void loadRewarded() {
    UnityAds.load(
      placementId: rewardedAdUnitId,
      onComplete: (placementId) => print('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  static showRewarded() {
    UnityAds.showVideoAd(
      placementId: rewardedAdUnitId,
      onStart: (placementId) => print('UnityAds Video Ad $placementId started'),
      onClick: (placementId) => print('UnityAds Video Ad $placementId click'),
      onSkipped: (placementId) {
        print('UnityAds Video Ad $placementId skipped');
      },
      onComplete: (placementId) {
        print('UnityAds Video Ad $placementId completed');
      },
      onFailed: (placementId, error, message) {
        print('UnityAds Video Ad $placementId failed: $error $message');
        loadRewarded();
      },
    );
  }
}

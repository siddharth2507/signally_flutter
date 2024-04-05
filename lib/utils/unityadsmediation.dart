import 'package:unity_mediation/unity_mediation.dart';

class UnityAdsUtils {
  static var gameID = '5591443';
  static var rewardedAdUnitId = 'Rewarded_Android';
  static var interstitialAdUnitId = 'Interstitial_Android';

  static Future<void> initUnityMediation() async {
    UnityMediation.initialize(
      gameId: gameID,
      onComplete: () {
        print('Initialization Complete');
        loadAds();
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  static void loadAds() {
    loadRewardedAd();
    loadInterstitialAd();
  }

  static void loadRewardedAd() {
    UnityMediation.loadRewardedAd(
      adUnitId: rewardedAdUnitId,
      onComplete: (adUnitId) {
        print('Rewarded Ad Load Complete $adUnitId');
      },
      onFailed: (adUnitId, error, message) =>
          print('Rewarded Ad Load Failed $adUnitId: $error $message'),
    );
  }

  static void loadInterstitialAd() {
    UnityMediation.loadInterstitialAd(
      adUnitId: interstitialAdUnitId,
      onComplete: (adUnitId) {
        print('Interstitial Ad Load Complete $adUnitId');
      },
      onFailed: (adUnitId, error, message) =>
          print('Interstitial Ad Load Failed $adUnitId: $error $message'),
    );
  }

  static void showInterstitialAd() {
    UnityMediation.showInterstitialAd(
      adUnitId: interstitialAdUnitId,
      onFailed: (adUnitId, error, message) =>
          print('Rewarded Ad $adUnitId failed: $error $message'),
      onStart: (adUnitId) => print('Rewarded Ad $adUnitId started'),
      onClick: (adUnitId) => print('Rewarded Ad $adUnitId click'),
      onClosed: (adUnitId) {
        print('Rewarded Ad $adUnitId closed');
        loadInterstitialAd();
      },
    );
  }

  static void showRewarededAd() {
    UnityMediation.showRewardedAd(
      adUnitId: rewardedAdUnitId,
      onFailed: (adUnitId, error, message) {
        print('Rewarded Ad $adUnitId failed: $error $message');
      },
      onStart: (adUnitId) => print('Rewarded Ad $adUnitId started'),
      onClick: (adUnitId) => print('Rewarded Ad $adUnitId click'),
      onRewarded: (adUnitId, reward) =>
          print('Rewarded Ad $adUnitId rewarded $reward'),
      onClosed: (adUnitId) {
        print('Rewarded Ad $adUnitId closed');
        loadRewardedAd();
      },
    );
  }
}

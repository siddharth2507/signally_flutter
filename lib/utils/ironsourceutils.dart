import 'package:ironsource_mediation/ironsource_mediation.dart';

class IronsourceUtils with LevelPlayInterstitialListener {
  static var IRNKEYID = '1e1f7a19d';

  static final IronsourceUtils _singleton = IronsourceUtils._internal();

  factory IronsourceUtils() {
    return _singleton;
  }

  IronsourceUtils._internal();

  initIronsource() async {
    IronSource.init(
        appKey: IRNKEYID,
        adUnits: [IronSourceAdUnit.Interstitial, IronSourceAdUnit.Banner]);
    IronSource.setMetaData({
      'is_test_suite': ['enable']
    });
    IronSource.validateIntegration();
    IronSource.setLevelPlayInterstitialListener(this);
    // IronSource.setAdaptersDebug(true);
    // IronSource.setConsent(true);
    // IronSource.launchTestSuite();
  }

  static loadInterstitial() {
    // LevelPlayInterstitialListener mLevelPlayInterstitialListener = new LevelPlayInterstitialListener();
    // IronSource.setLevelPlayInterstitialListener(this);
    IronSource.loadInterstitial();
  }

  static showInterstitial() async {
    if (await IronSource.isInterstitialReady()) {
      IronSource.showInterstitial();
    } else {
      print("Wait next to load");
      loadInterstitial();
    }
  }

  @override
  void onAdClicked(IronSourceAdInfo adInfo) {
    // TODO: implement onAdClicked
    print("IRON onAdClicked ${adInfo.adUnit}");
  }

  @override
  void onAdClosed(IronSourceAdInfo adInfo) {
    // TODO: implement onAdClosed
    print("IRON onAdClosed ${adInfo.adUnit}");
  }

  @override
  void onAdLoadFailed(IronSourceError error) {
    // TODO: implement onAdLoadFailed
    print("IRON onAdLoadFailed ${error.message}");
  }

  @override
  void onAdOpened(IronSourceAdInfo adInfo) {
    // TODO: implement onAdOpened
  }

  @override
  void onAdReady(IronSourceAdInfo adInfo) {
    // TODO: implement onAdReady
    print("IRON IronSourceAdInfo ${adInfo.adUnit}");
  }

  @override
  void onAdShowFailed(IronSourceError error, IronSourceAdInfo adInfo) {
    // TODO: implement onAdShowFailed
    print("IRON onAdShowFailed ${error.message}");
  }

  @override
  void onAdShowSucceeded(IronSourceAdInfo adInfo) {
    // TODO: implement onAdShowSucceeded
    print("IRON onAdShowSucceeded ${adInfo.adUnit}");
  }
}

class IronsourceBannerUtils with LevelPlayBannerListener {
  loadBanner() {
    IronSource.setLevelPlayBannerListener(this);
  }

  showBanner() {
    final size = IronSourceBannerSize.BANNER;
    return IronSource.loadBanner(
        size: size,
        position: IronSourceBannerPosition.Bottom,
        verticalOffset: -50,
        placementName: 'DefaultBanner');
  }

  @override
  void onAdLoadFailed(IronSourceError error) {
    print("Banner - onAdLoadFailed Error:$error");
    // _isBannerLoaded = false;
  }

  @override
  void onAdClicked(IronSourceAdInfo adInfo) {
    print("Banner - onAdClicked: $adInfo");
  }

  @override
  void onAdScreenDismissed(IronSourceAdInfo adInfo) {
    print("Banner - onAdScreenDismissed: $adInfo");
  }

  @override
  void onAdScreenPresented(IronSourceAdInfo adInfo) {
    print("Banner - onAdScreenPresented: $adInfo");
  }

  @override
  void onAdLeftApplication(IronSourceAdInfo adInfo) {
    print("Banner - onAdLeftApplication: $adInfo");
  }

  @override
  void onAdLoaded(IronSourceAdInfo adInfo) {
    // TODO: implement onAdLoaded
    print("Banner - onAdLoaded: $adInfo");
  }
}

/*
abstract class LevelPlayInterstitialListener {
  /// Indicates that the interstitial ad was loaded successfully.
  /// - [adInfo] includes information about the loaded ad.
  ///
  /// Native SDK Reference
  /// - Android: onAdReady
  /// -     iOS: didLoadWithAdInfo
  void onAdReady(IronSourceAdInfo adInfo);
  /// Indicates that the ad failed to be loaded
  ///
  /// Native SDK Reference
  /// - Android: onAdLoadFailed
  /// -     iOS: didFailToLoadWithError
  void onAdLoadFailed(IronSourceError error);
  /// Invoked when the Interstitial Ad Unit has opened, and user left the application screen.
  /// - This is the impression indication.
  ///
  /// Native SDK Reference
  /// - Android: onAdOpened
  /// -     iOS: didOpenWithAdInfo
  void onAdOpened(IronSourceAdInfo adInfo);
  /// Invoked when the interstitial ad closed and the user went back to the application screen.
  ///
  /// Native SDK Reference
  /// - Android: onAdClosed
  /// -     iOS: didCloseWithAdInfo
  void onAdClosed(IronSourceAdInfo adInfo);
  /// The interstitial ad failed to show.
  ///
  /// Native SDK Reference
  /// - Android: onAdShowFailed
  /// -     iOS: didFailToShowWithError
  void onAdShowFailed(IronSourceError error, IronSourceAdInfo adInfo);
  /// Invoked when end user clicked on the interstitial ad
  ///
  /// Native SDK Reference
  /// - Android: onAdClicked
  /// -     iOS: didClickWithAdInfo
  void onAdClicked(IronSourceAdInfo adInfo);
  /// Invoked before the interstitial ad was opened, and before the InterstitialOnAdOpenedEvent is reported.
  /// This callback is not supported by all networks, and we recommend using it only if
  /// it's supported by all networks you included in your build.
  ///
  /// Native SDK Reference
  /// - Android: onAdShowSucceeded
  /// -     iOS: didShowWithAdInfo
  void onAdShowSucceeded(IronSourceAdInfo adInfo);
}*/

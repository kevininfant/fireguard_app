import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  bool _isInitialized = false;
  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  // Official Google AdMob Test Ad Unit IDs
  static String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android test banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS test banner
    }
    return '';
  }

  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android test interstitial
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS test interstitial
    }
    return '';
  }

  static String get rewardedAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Android test rewarded
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // iOS test rewarded
    }
    return '';
  }

  /// Initializes AdMob SDK safely
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (!isSupported) {
      debugPrint('AdMob not supported on current platform (${kIsWeb ? 'Web' : Platform.operatingSystem}). Simulation active.');
      _isInitialized = true;
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('Google Mobile Ads (AdMob) initialized successfully.');
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
    }
  }

  /// Creates and loads a Banner Ad
  BannerAd? createBannerAd({
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
    AdSize size = AdSize.banner,
  }) {
    if (!isSupported) return null;

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  /// Loads and displays an AdMob Rewarded Video Ad
  Future<void> showRewardedAd({
    required Function(int pointsEarned) onRewardEarned,
    Function()? onAdClosed,
    Function(String error)? onAdFailed,
  }) async {
    if (!isSupported) {
      // Simulation on non-mobile platforms
      await Future.delayed(const Duration(milliseconds: 600));
      onRewardEarned(150); // Grants 150 bonus safety points in simulation
      onAdClosed?.call();
      return;
    }

    try {
      RewardedAd.load(
        adUnitId: rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                onAdClosed?.call();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                onAdFailed?.call(error.message);
              },
            );

            ad.show(
              onUserEarnedReward: (adWithoutView, reward) {
                final amount = reward.amount > 0 ? reward.amount.toInt() : 150;
                onRewardEarned(amount);
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('Rewarded ad failed to load: ${error.message}');
            onAdFailed?.call(error.message);
          },
        ),
      );
    } catch (e) {
      debugPrint('showRewardedAd exception: $e');
      onAdFailed?.call(e.toString());
    }
  }

  /// Loads and displays an AdMob Interstitial Ad
  Future<void> showInterstitialAd({
    Function()? onAdClosed,
    Function(String error)? onAdFailed,
  }) async {
    if (!isSupported) {
      await Future.delayed(const Duration(milliseconds: 400));
      onAdClosed?.call();
      return;
    }

    try {
      InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                onAdClosed?.call();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                onAdFailed?.call(error.message);
              },
            );
            ad.show();
          },
          onAdFailedToLoad: (error) {
            debugPrint('Interstitial ad failed to load: ${error.message}');
            onAdFailed?.call(error.message);
          },
        ),
      );
    } catch (e) {
      debugPrint('showInterstitialAd exception: $e');
      onAdFailed?.call(e.toString());
    }
  }
}

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  RewardedAd? _rewardedAd;
  
  // Test Ad Unit ID (Production me aapko AdMob se real ID milegi)
  final String _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  // Initialize AdMob SDK
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // Load Rewarded Ad
  void loadRewardedAd({required Function onAdLoaded}) {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  // Show Rewarded Ad
  void showRewardedAd({required Function(int rewardAmount) onUserEarnedReward}) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // User ko 10 coins reward do
          onUserEarnedReward(10);
        },
      );
      _rewardedAd = null; // Ad reset kar do
    }
  }
}

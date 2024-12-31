import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsMob {
  static String? get RewardAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1187562464380634/8606552364';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1187562464380634/8606552364';
    }
    return null;
  }

  static String? get RewardAdIntertial {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1187562464380634/8698067617';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1187562464380634/8698067617';
    }
    return null;
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) {

    },
    onAdFailedToLoad: (ad, error) {
      ad.dispose();

    },
    onAdOpened: (ad) {

    },
    onAdClosed: (ad){},
  );
}

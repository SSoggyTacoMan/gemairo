import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gemairo/apis/saaf.dart';

class Ads {
  String app;
  bool initialized = false;
  int navigations = 0;

  Ads._({required this.app});

  static final Map<String, Ads> _adsInstances = {};

  factory Ads._instanceFor({required String app}) {
    return _adsInstances.putIfAbsent(app, () {
      return Ads._(app: app);
    });
  }

  static Ads? get instance {
    if (Platform.isAndroid || Platform.isIOS) {
      String defaultAppInstance = 'gemairo';
      return Ads._instanceFor(app: defaultAppInstance);
    }
    return null;
  }

  Future<void> initialize() async {
    if (initialized == true) {
      return;
    }

    initialized = true;
  }

  Future<void> handleNavigate(String screenName) async {
    navigations++;

    String unifiedName = mapClass(screenName);
    await FirebaseAnalytics.instance
        .logScreenView(screenName: unifiedName, screenClass: unifiedName);
  }

  Widget bannerAd(BuildContext context) {
    return const SizedBox();
  }

  Future<void> showInterstitial() async {
    return;
  }

  Future<void> loadIntersitial() async {
    return;
  }

  Future checkGDPRConsent() async {
    return;
  }

  Future loadGDPRForm() async {
    return;
  }
}

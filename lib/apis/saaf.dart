import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:gemairo/apis/account_manager.dart';
import 'package:gemairo/hive/adapters.dart';
import 'package:gemairo/hive/extentions.dart';

class Saaf {
  String app;
  bool initialized = false;

  Saaf._({required this.app});

  static final Map<String, Saaf> _saafInstances = {};

  factory Saaf._instanceFor({required String app}) {
    return _saafInstances.putIfAbsent(app, () {
      return Saaf._(app: app);
    });
  }

  static Saaf? get instance {
    if (Platform.isAndroid || Platform.isIOS) {
      String defaultAppInstance = 'gemairo';
      return Saaf._instanceFor(app: defaultAppInstance);
    }
    return null;
  }

  Future<void> initialize() async {
    if (initialized == true) {
      return;
    }

    initialized = true;
    await setAdRequest();
  }

  Future<void> setAdRequest() async {
    Account account = AccountManager().getActive();
    Person? person = account.activeProfile;

    if (person == null) {
      return;
    }

    // Analytics
    FirebaseAnalytics.instance.setUserId(id: person.uuid.toString());
    FirebaseAnalytics.instance
        .setUserProperty(name: 'service', value: account.apiType.toString());
    if (account.apiType == AccountAPITypes.magister) {
      FirebaseAnalytics.instance.setUserProperty(
          name: 'school', value: Uri.parse(account.apiStorage!.baseUrl).host);
      FirebaseAnalytics.instance
          .setUserProperty(name: 'type', value: account.accountType.toString());
    }
  }

  Widget bannerAd(BuildContext context) {
    return const SizedBox.shrink();
  }

  Future<void> handleTakeover(context) async {
    return;
  }
}

Map<String, List<RegExp>> getClassMappings() {
  var jsonMap =
      json.decode(FirebaseRemoteConfig.instance.getString("class_mappings"));
  Map<String, List<RegExp>> classMappings = {};

  jsonMap.forEach((key, value) {
    List<String> regexStrings = List<String>.from(value);
    classMappings[key] = regexStrings
        .map((regexStr) => RegExp(regexStr, caseSensitive: false))
        .toList();
  });

  return classMappings;
}

String mapClass(String className, {Map<String, List<RegExp>>? classMappings}) {
  if (classMappings is! Map<String, List<RegExp>>) {
    // prevent unnececary fetching and calculation when running this in a loop, pass classMappings as parameter
    classMappings = getClassMappings();
  }

  String unifiedName = className;
  classMappings.forEach((key, regexList) {
    for (RegExp regex in regexList) {
      if (regex.hasMatch(className)) {
        unifiedName = key;
        break;
      }
    }
  });

  return unifiedName;
}

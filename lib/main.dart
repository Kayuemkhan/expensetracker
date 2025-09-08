import 'package:expensetracker/app/core/values/app_values.dart';
import 'package:expensetracker/app/my_app.dart';
import 'package:expensetracker/flavors/build_config.dart';
import 'package:expensetracker/flavors/env_config.dart';
import 'package:expensetracker/flavors/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  EnvConfig devConfig = EnvConfig(
    appName: AppValues.appName,
    baseUrl: "",
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  runApp(const MyApp());
}


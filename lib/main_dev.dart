import 'package:expensetracker/app/my_app.dart';
import 'package:expensetracker/flavors/build_config.dart';
import 'package:expensetracker/flavors/env_config.dart';
import 'package:expensetracker/flavors/environment.dart';
import 'package:flutter/material.dart';



void main() {
  EnvConfig devConfig = EnvConfig(
    appName: "Flutter GetX Template Dev",
    baseUrl: "https://api.github.com",
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  runApp(const MyApp());
}

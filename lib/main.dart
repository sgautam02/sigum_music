import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signum_music/pages/NavigationPage.dart';
import 'package:signum_music/utils/AppColor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
           seedColor: AppColor.mainColor,
      ),),
      darkTheme: ThemeData.dark(),
      home: const NavigationPage()
    );
  }
}


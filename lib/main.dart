import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/Theme.dart';
import 'screens/movie_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movie',
      theme: CustomTheme.darkTheme,
      // defined route itongn GetX
      // getPages: [
      //   GetPage(name: '/', page: () => HomeScreen()),
      //   GetPage(name: '/detail', page: () => DetailScreen()),
      // ],
      // initialRoute: '/',

      home: MovieScreen(),
    );
  }
}

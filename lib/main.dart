import 'package:flutter/material.dart';
import 'package:selfmakeserver/page/youtube_like_bottom_navigationbar.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterアプリで自宅の自前サーバーとやり取りする',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 0, 234)),
      ),
      home: const YoutubeLikeBottomNavigationBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}


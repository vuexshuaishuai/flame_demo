import 'package:demo_flame/demo4/demo4_main.dart';
import 'package:demo_flame/demo5/demo5_main.dart';
import 'package:demo_flame/demo6/demo6_main.dart';
import 'package:demo_flame/demo7/demo7_main.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import './demo1/demo_main.dart';
import 'demo2/demo2_main.dart';
import 'demo3/demo3_main.dart';

void main() async{
  ///设置横屏
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Demo",
      home: Scaffold(
        body: HomeGame(),
      ),
    );
  }
}

class HomeGame extends StatelessWidget {
  const HomeGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      // game: DemoMain(),
      // game: DemoMain2(),
      // game: DemoMain3(),
      // game: DemoMain4(),
      // game: DemoMain5(),
      // game: DemoMain6(),
      game: DemoMain7(),
    );
  }
}


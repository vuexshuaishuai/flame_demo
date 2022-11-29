import 'dart:math';

import 'package:demo_flame/demo2/demo2_main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class DemoMain3 extends FlameGame with TapDetector,PanDetector{
  late final Demo2LotsHeroComponent player;
  late final RectangleHitbox box;

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    player = Demo2LotsHeroComponent();
    box = RectangleHitbox()..debugMode = false;
    player.add(box);
    add(player);
  }

  final double step = 10;

  double _counter = 0;

  @override
  void onTap() {
    // TODO: implement onTap
    super.onTap();
    print('点击了onTap');
    _counter++;
    player.angle = _counter * pi / 2;
  }

  @override
  void onTapCancel() {
    // TODO: implement onTapCancel
    super.onTapCancel();
    print('点击了onTapCancel');
    box.debugMode = false;
  }

  @override
  void onTapDown(TapDownInfo info) {
    // TODO: implement onTapDown
    super.onTapDown(info);
    print('点击了onTapDown');
    box.debugMode = true;
  }

  @override
  void onTapUp(TapUpInfo info) {
    // TODO: implement onTapUp
    super.onTapUp(info);
    print('点击了onTapUp');
    box.debugMode = false;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // TODO: implement onPanUpdate
    super.onPanUpdate(info);
    player.position.add(info.delta.global);
  }

}
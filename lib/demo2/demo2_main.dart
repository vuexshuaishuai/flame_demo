import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class DemoMain2 extends FlameGame with HasDraggables {

  late final JoystickComponent joyStick;

  late final Demo2LotsHeroComponent player;

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    //创建操作杆
    joyStick = JoystickComponent(
      knob: CircleComponent(radius: 25, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40)
    );
    add(joyStick);
    //创建人物
    player = Demo2LotsHeroComponent();
    add(player);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if(!joyStick.delta.isZero()){
      Vector2 ds = joyStick.relativeDelta * player.speed * dt;
      player.move(ds);
      //旋转
      player.angle = joyStick.delta.screenAngle();
    }else{
      player.angle = 0;
    }
  }
}

class Demo2LotsHeroComponent extends SpriteAnimationComponent with HasGameRef {
  Demo2LotsHeroComponent(): super(
      size: Vector2(100, 74),
      anchor: Anchor.center
  );

  @override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    super.onGameResize(size);
    position = size / 2;
  }

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    List<Sprite> lotsHero = [];
    for(int i = 0;i < 9;i++){
      lotsHero.add(await gameRef.loadSprite("adventurer/adventurer-bow-0$i.png"));
    }
    animation = SpriteAnimation.spriteList(lotsHero, stepTime: 0.15);
    position = gameRef.size / 2;
    add(RectangleHitbox()..debugMode = true);
  }

  double speed = 200.0;

  void move(Vector2 ds){
    position.add(ds);
  }
}
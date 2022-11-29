import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class DemoMain5 extends FlameGame with TapDetector{
  late final Demo5AnimateMonster animateMonster;
  late final Demo5LotsHeroComponent hero;

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    const String src = "adventurer/animatronic.png";
    await images.load(src);
    var image = images.fromCache(src);
    const int rowCount = 6;
    const int columnCount = 13;
    Vector2 singleSize = Vector2(image.width / columnCount, image.height / rowCount);
    // List images
    SpriteAnimation animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: rowCount * columnCount,
        amountPerRow: columnCount,
        stepTime: 0.05,
        textureSize: singleSize
      )
    );
    animateMonster = Demo5AnimateMonster(animation: animation, size: singleSize);
    add(animateMonster);
    hero = Demo5LotsHeroComponent();
    hero.position = Vector2(200, 200);
    add(hero);
  }

  @override
  void onTap() {
    // TODO: implement onTap
    super.onTap();
    animateMonster.loss(100);
  }

}

class Demo5LotsHeroComponent extends SpriteAnimationComponent with Liveable{
  Demo5LotsHeroComponent(): super(
      size: Vector2(100, 74),
      anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    List<Sprite> lotsHero = [];
    for(int i = 0;i < 9;i++){
      lotsHero.add(await Sprite.load("adventurer/adventurer-bow-0$i.png"));
    }
    animation = SpriteAnimation.spriteList(lotsHero, stepTime: 0.15);
    initPaint(lifePoint: 2000, currentLife: 2000, lifeColor: Colors.red);
  }
}

class Demo5AnimateMonster extends SpriteAnimationComponent with HasGameRef, Liveable {
  Demo5AnimateMonster({
    required SpriteAnimation animation,
    required Vector2 size,
    Vector2? position
  }):super(
      animation: animation,
      size: size,
      position: position,
      anchor: Anchor.center
  );

  // Paint _outlinePaint = Paint();
  // Paint _filePaint = Paint();

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    position = gameRef.size / 2;
    // add(RectangleHitbox()..debugMode = true);
    initPaint(lifePoint: 1000, currentLife: 1000, lifeColor: Colors.blue);
  }

  // @override
  // void render(Canvas canvas){
  //   super.render(canvas);
  //   // canvas.drawCircle(Offset.zero, 30, Paint()..color = const Color(0xFF25B657));
  //   //血条颜色
  //   Color lifeColor = Colors.red;
  //   //外框颜色
  //   Color outlineColor = Colors.white;
  //   final double offsetY = 10;
  //   final double widthRadio = 0.8;
  //   final double lifeBarHeight = 4;
  //   final double lifeProgress = 0.8;
  //
  //   Rect rect = Rect.fromCenter(
  //     center: Offset(size.x / 2, lifeBarHeight / 2 - offsetY),
  //     width: size.x * widthRadio,
  //     height: lifeBarHeight
  //   );
  //   Rect lifeRect = Rect.fromPoints(
  //     rect.topLeft,
  //     rect.bottomRight - Offset(rect.width * (1 - lifeProgress), 0)
  //     // rect.topLeft + Offset(rect.width * (1 - lifeProgress), 0),
  //     // rect.bottomRight
  //   );
  //   _outlinePaint
  //     ..color = outlineColor
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 1;
  //   _filePaint.color = lifeColor;
  //   canvas.drawRect(rect, _outlinePaint);
  //   canvas.drawRect(lifeRect, _filePaint);
  // }
}

//封装血条
mixin Liveable on PositionComponent {
  final Paint _outlinePaint = Paint();
  final Paint _fillPaint = Paint();
  //生命上限
  late double lifePoint;
  //当前生命值
  late double _currentLife;

  //初始化
  void initPaint({
    required double lifePoint,
    required double currentLife,
    Color lifeColor = Colors.red,
    Color outlineColor = Colors.white
  }){
    //血条外边
    _outlinePaint
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    _fillPaint.color = lifeColor;

    this.lifePoint = lifePoint;
    _currentLife = currentLife;
  }

  double get _progress => _currentLife / lifePoint;

  void loss(double point){
    _currentLife -= point;
    if(_currentLife <= 0){
      _currentLife = 0;
      //回调: 人物死亡
      onDied();
    }
  }

  void onDied(){
    print("死了死了");
    //移除
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
    //定义: 血条距人物头部的偏移量
    const double offsetY = 10;
    //定义: 血条宽度
    const double widthRadio = 1.5;
    //定义: 血条高度
    const double lifeBarHeight = 4;

    Rect rect = Rect.fromCenter(
      center: Offset(size.x / 2, lifeBarHeight / 2 - offsetY),
      width: size.x / 2 * widthRadio,
      height: lifeBarHeight
    );
    Rect lifeRect = Rect.fromPoints(
      rect.topLeft,
      rect.bottomRight - Offset(rect.width * (1 - _progress), 0)
    );
    canvas.drawRect(rect, _outlinePaint);
    canvas.drawRect(lifeRect, _fillPaint);
  }
}
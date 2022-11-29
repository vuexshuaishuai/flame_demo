import 'dart:ui' as DartUI;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class DemoMain6 extends FlameGame with TapDetector{

  late final Demo6Monster monster;

  @override
  void onTap() {
    // TODO: implement onTap
    super.onTap();
    monster.loss(Random().nextInt(200));
  }

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    //添加英雄
    add(Demo6Hero()..position = Vector2(size.x * 0.2, size.y / 2));
    //添加怪物
    const String src = "adventurer/animatronic.png";
    await images.load(src);
    var image = images.fromCache(src);
    Vector2 monsterSize = Vector2(image.width / 13, image.height / 6);
    monster = Demo6Monster(
        image: image,
        rowCount: 6,
        columnCount: 13,
        size: monsterSize
    )..position = Vector2(size.x * 0.8, size.y / 2);
    add(monster);

  }
}

class Demo6Hero extends SpriteAnimationComponent with LiveableDemo6{
  Demo6Hero(): super(
      size: Vector2(100, 74),
      anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    List<Sprite> sprites = [];
    for(int i = 0;i < 9;i++){
      sprites.add(await Sprite.load("adventurer/adventurer-bow-0$i.png"));
    }
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.15);
    //初始化: 血量
    initPaint(lifePoint: 1000, currentLife: 1000, lifeColor: Colors.red);
  }

}

class Demo6Monster extends SpriteAnimationComponent with HasGameRef, LiveableDemo6 {
  //怪物图像
  final DartUI.Image image;
  //怪物行数
  final int rowCount;
  //怪物列数
  final int columnCount;

  Demo6Monster({
    required this.image,
    required this.rowCount,
    required this.columnCount,
    //大小
    required Vector2 size,
  }): super(
    size: size,
    anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: rowCount * columnCount,
        amountPerRow: columnCount,
        stepTime: 0.05,
        textureSize: size
      )
    );
    //初始化血量
    initPaint(lifePoint: 2000, currentLife: 2000, lifeColor: Colors.red);
  }
}

//封装血条
mixin LiveableDemo6 on PositionComponent {
  final Paint _outlinePaint = Paint();
  final Paint _fillPaint = Paint();
  //生命上限
  late double lifePoint;
  //当前生命值
  late double _currentLife;
  //文本处理
  late TextComponent _text;
  //伤害说明
  final DamageText _damageText = DamageText();

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
    ///添加血条说明
    _text = TextComponent(
      textRenderer: TextPaint(style: const TextStyle(
          color: Colors.white,
          fontSize: 10
      ))
    );
    updateLife();
    _text.position = Vector2(size.x / 2 - _text.width / 2, -(10 + _text.height + 2));
    add(_text);
    ///添加伤害说明
    add(_damageText);
  }

  double get _progress => _currentLife / lifePoint;

  //减少血量
  void loss(int point){
    _currentLife -= point;
    _damageText.addDamage(-point.toInt(), isCritical: point.toInt() % 2 == 0);
    if(_currentLife <= 0){
      _currentLife = 0;
      //回调: 人物死亡
      onDied();
    }
  }

  //修改血量描述
  void updateLife(){
    _text.text = "HP ${_currentLife.toInt()}";
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

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    updateLife();
  }
}

//伤害描述
class DamageText extends PositionComponent {
  TextStyle getDamageTextStyle({
    Color fontColor = Colors.white,
    double fontSize = 14
  }){
    return TextStyle(
        fontSize: fontSize,
        color: fontColor,
        fontFamily: "Menlo",
        shadows: const [
          Shadow(
              color: Colors.red,
              offset: Offset(1, 1),
              blurRadius: 1
          )
        ]
    );
  }

  Future<void> addDamage(int damage, {bool isCritical = false}) async{
    //校验: 防止快速点击导致文字遮挡
    Vector2 textOffset = Vector2(-30, 0);
    if(children.isNotEmpty){
      if(children.last is PositionComponent){
        PositionComponent last = children.last as PositionComponent;
        textOffset = last.position + Vector2(5, last.height + 10);
      }
    }

    Color fontColor = isCritical ? Colors.amber : Colors.white;
    double fontSize = isCritical ? 18 : 14;
    //正常伤害
    TextComponent damageText = TextComponent(
      textRenderer: TextPaint(style: getDamageTextStyle(fontColor: fontColor, fontSize: fontSize)),
    );
    damageText.text = damage.toString();
    damageText.position = textOffset;
    //暴击伤害
    TextComponent criticalText = TextComponent(
        textRenderer: TextPaint(style: getDamageTextStyle(fontColor: fontColor))
    );
    criticalText.text = "暴击";
    criticalText.position = textOffset + Vector2(
        damageText.width - criticalText.width / 2,
        -criticalText.height / 2
    );
    add(damageText);
    //添加暴击伤害
    if(isCritical){
      add(criticalText);
    }
    await Future.delayed(const Duration(seconds: 1), (){
      damageText.removeFromParent();
      criticalText.removeFromParent();
    });
  }
}
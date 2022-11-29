import "dart:ui" as DartUI;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';

class DemoMain7 extends FlameGame with TapDetector, PanDetector{
  late final Demo7Monster monster;
  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    const String src = "adventurer/animatronic.png";
    await images.load(src);
    DartUI.Image image = images.fromCache(src);
    const int rowCount = 6;
    const int columnCount = 13;
    Vector2 monsterSize = Vector2(image.width / columnCount, image.height / rowCount);
    monster = Demo7Monster(
      image: image,
      rowCount: rowCount,
      columnCount: columnCount,
      size: monsterSize
    );
    monster.position = Vector2(size.x / 2 - monsterSize.x / 2, size.y / 2 - monsterSize.y / 2);
    add(monster);
  }

  @override
  void onTapDown(TapDownInfo info) {
    // TODO: implement onTapDown
    super.onTapDown(info);
    Vector2 target = info.eventPosition.global;
    add(TouchIndicator(position: target));
    monster.move(target);
  }

  double ds = 0;

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // TODO: implement onPanUpdate
    super.onPanUpdate(info);
    //注释: 当间隔长度大于10再去添加星星
    ds += info.delta.global.length;
    if(ds > 10){
      add(TouchIndicator(position: info.eventPosition.global));
      ds = 0;
    }
  }


}

class Demo7Monster extends SpriteAnimationComponent {
  //怪物图像
  final DartUI.Image image;
  //怪物行数
  final int rowCount;
  //怪物列数
  final int columnCount;
  Demo7Monster({
    required this.image,
    required this.rowCount,
    required this.columnCount,
    required Vector2 size,
  }): super(
    size: size
  );

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: rowCount * columnCount,
        stepTime: 0.01,
        amountPerRow: columnCount,
        textureSize: size
      )
    );
  }

  final double _speed = 100;
  void move(Vector2 target){
    //移除之前的点击
    removeAll(children.whereType<MoveEffect>());
    target = target - size / 2;
    double timeMs = (target - position).length / _speed;
    add(MoveEffect.to(target, EffectController(
      duration: timeMs
    )));
  }
}

class TouchIndicator extends SpriteAnimationComponent {
  TouchIndicator({required Vector2 position}): super(
    size: Vector2(60, 60),
    anchor: Anchor.center,
    position: position
  );
  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    List<Sprite> sprites = [];
    for(int i = 1;i < 11;i++){
      sprites.add(await Sprite.load("touch/star_${'$i'.padLeft(2, '0')}.png"));
    }
    removeOnFinish = true;
    animation = SpriteAnimation.spriteList(sprites, stepTime: 1/15, loop: false);
  }
}
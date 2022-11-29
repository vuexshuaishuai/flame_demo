import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class DemoMain4 extends FlameGame {
  // late final Adventurer player;
  late final Monster monster;
  late final AnimateMonster animateMonster;

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    //加载SpriteSheet
    const String src = "adventurer/animatronic.png";
    await images.load(src);
    var image = images.fromCache(src);
    // SpriteSheet sheet = SpriteSheet.fromColumnsAndRows(image: image, columns: 13, rows: 6);

    ///加载单图
    // Sprite sprite = sheet.getSpriteById(0);
    // //初始化Monster
    // Vector2 monsterSize = Vector2(64, 64);
    // monster = Monster(
    //   sprite: sprite,
    //   size: monsterSize,
    // );
    // add(monster);

    ///加载精灵图
    // int frameCount = sheet.rows * sheet.columns;
    // List<Sprite> sprites = List.generate(frameCount, sheet.getSpriteById);
    // SpriteAnimation animation = SpriteAnimation.spriteList(sprites, stepTime: 0.05, loop: true);
    // animateMonster = AnimateMonster(animation: animation, size: monsterSize);
    // add(animateMonster);

    ///加载精灵图简单写法
    const int rowCount = 6;
    const int columnCount = 13;
    Vector2 singleImageSize = Vector2(image.width / columnCount, image.height / rowCount);
    SpriteAnimationComponent animationPerson= SpriteAnimationComponent.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        //精灵图上的图片的总个数
        amount: rowCount * columnCount,
        amountPerRow: columnCount,

        //图片切换间隔
        stepTime: 0.05,
        //单个图片大小
        textureSize: singleImageSize,
        loop: true
      ),
      size: singleImageSize,
      removeOnFinish: false,
      position: Vector2(100, 100),
    );
    add(animationPerson);

  }
}

class Monster extends SpriteComponent with HasGameRef{
  Monster({
    required Sprite sprite,
    required Vector2 size,
    Vector2? position,
  }) : super(
    sprite: sprite,
    size: size,
    position: position,
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    position = gameRef.size / 2;
    add(RectangleHitbox()..debugMode = true);
  }
}

class AnimateMonster extends SpriteAnimationComponent with HasGameRef {
  AnimateMonster({
    required SpriteAnimation animation,
    required Vector2 size,
    Vector2? position
  }):super(
    animation: animation,
    size: size,
    position: position,
    anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    position = gameRef.size / 2;
    add(RectangleHitbox()..debugMode = true);
  }
}
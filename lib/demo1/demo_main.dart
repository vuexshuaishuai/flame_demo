import 'package:flame/game.dart';
import 'package:flame/components.dart';

class DemoMain extends FlameGame {
  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    //案例一: 单个图片
    // await add(HeroComponent());
    //案例二: 多个图片组合成动效
    await add(LotsHeroComponent());
  }
}

///案例一: 单个图片
class HeroComponent extends SpriteComponent {
  HeroComponent() : super(
    size: Vector2(100, 74),
    anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async{
    // TODO: implement onLoad
    super.onLoad();
    sprite = await Sprite.load("adventurer/adventurer-bow-00.png");
  }

  @override
  void onGameResize(Vector2 size) {
    // TODO: implement onGameResize
    super.onGameResize(size);
    position = size / 2;
  }
}

///案例二: 多个图片组合成动效
class LotsHeroComponent extends SpriteAnimationComponent {
  LotsHeroComponent(): super(
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
      lotsHero.add(await Sprite.load("adventurer/adventurer-bow-0$i.png"));
    }
    animation = SpriteAnimation.spriteList(lotsHero, stepTime: 0.15);
  }
}
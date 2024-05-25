import 'package:flutter_test/flutter_test.dart';

export 'material_icon_font_loader.dart';
export 'pubspec_font_loader.dart';

abstract class RobotFontLoader {
  bool _loaded = false;
  bool get loaded => _loaded;

  void setLoaded() => _loaded = true;

  Future<void> load();
}

class RobotFontLoaderManager {
  static final RobotFontLoaderManager instance =
      RobotFontLoaderManager._internal();

  factory RobotFontLoaderManager() {
    return instance;
  }

  RobotFontLoaderManager._internal();
  final List<RobotFontLoader> _loaders = [];

  void add(RobotFontLoader loader) => _loaders.add(loader);
  void clean() => _loaders.clear();

  Future<void> load() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (var loader in _loaders) {
      if (!loader.loaded) {
        await loader.load();
        loader.setLoaded();
      }
    }
  }
}

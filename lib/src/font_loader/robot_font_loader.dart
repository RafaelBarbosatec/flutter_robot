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

  bool get isEmpty => _loaders.isEmpty;

  void add(RobotFontLoader loader) {
    final contains =
        _loaders.any((element) => element.runtimeType == loader.runtimeType);
    if (!contains) {
      _loaders.add(loader);
    }
  }

  void addAll(List<RobotFontLoader> loaders) {
    loaders.forEach(add);
  }

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

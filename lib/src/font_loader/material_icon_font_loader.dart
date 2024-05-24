import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/services.dart';
import 'package:flutter_robot/src/font_loader/robot_font_loader.dart';
import 'package:platform/platform.dart';

class MaterialIconsFontLoader extends RobotFontLoader {
  @override
  Future<void> load() async {
    const FileSystem fs = LocalFileSystem();
    const Platform platform = LocalPlatform();

    final Directory flutterRoot = fs.directory(
      platform.environment['FLUTTER_ROOT'],
    );

    final File iconFont = flutterRoot.childFile(
      fs.path.join(
        'bin',
        'cache',
        'artifacts',
        'material_fonts',
        'MaterialIcons-Regular.otf',
      ),
    );

    final Future<ByteData> bytes = Future<ByteData>.value(
      iconFont.readAsBytesSync().buffer.asByteData(),
    );

    await (FontLoader('MaterialIcons')..addFont(bytes)).load();
  }
}

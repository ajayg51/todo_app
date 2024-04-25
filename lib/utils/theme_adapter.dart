import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/theme_model.dart';

class ThemeAdapter extends TypeAdapter<ThemeModel> {
  @override
  int get typeId => 1;

  @override
  ThemeModel read(BinaryReader reader) {
    final isLightMode = reader.read();

    return ThemeModel(isLightMode: isLightMode);
  }

  @override
  void write(BinaryWriter writer, ThemeModel obj) {
    writer.write(obj.isLightMode);
  }
}

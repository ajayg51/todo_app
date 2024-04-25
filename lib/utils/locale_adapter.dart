import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/locale_model.dart';

class LocaleAdapter extends TypeAdapter<LocaleModel> {
  @override
  int get typeId => 2;

  @override
  LocaleModel read(BinaryReader reader) {
    final langCode = reader.read();
    return LocaleModel(langCode: langCode);
  }

  @override
  void write(BinaryWriter writer, LocaleModel obj) {
    writer.write(obj.langCode);
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/task_model.dart';

class TaskAdapter extends TypeAdapter<TaskModel> {
  @override
  int get typeId => 0;

  @override
  TaskModel read(BinaryReader reader) {
    final id = reader.read();
    final isCompleted = reader.read();
    final taskName = reader.read();

    return TaskModel(
      id :id,
      isCompleted: isCompleted,
      taskName: taskName,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.write(obj.id);
    writer.write(obj.isCompleted);
    writer.write(obj.taskName);
  }
}

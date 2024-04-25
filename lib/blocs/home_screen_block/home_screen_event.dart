import 'package:todo_app/models/task_model.dart';

abstract class TaskEvent {}

class TasksInitialEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent{
  TaskModel task;
  AddTaskEvent({required this.task});
}


class MarkTaskCompletedEvent extends TaskEvent{
  TaskModel task;
  MarkTaskCompletedEvent({required this.task});
}


class DeleteTaskEvent extends TaskEvent{
  TaskModel task;
  DeleteTaskEvent({required this.task});
}

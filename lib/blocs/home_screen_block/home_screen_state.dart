// import 'package:todo_app/models/task_model.dart';

import 'package:todo_app/models/task_model.dart';

abstract class TaskState {}

class TasksDummyState extends TaskState {}

class TasksInitialState extends TaskState {
  final List<TaskModel> taskList;
  TasksInitialState({required this.taskList});
}

class TasksState extends TaskState {
  final List<TaskModel> taskList;
  TasksState({required this.taskList});
}

// class TasksState extends TaskState {
//   final List<TaskModel> taskList;
//   TasksState({required this.taskList});
// }

// class CompletedTasksState extends TaskState {
//   final List<TaskModel> completedTaskList;
//   CompletedTasksState({required this.completedTaskList});
// }

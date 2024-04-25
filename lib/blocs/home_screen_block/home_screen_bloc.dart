import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/blocs/home_screen_block/home_screen_event.dart';
import 'package:todo_app/blocs/home_screen_block/home_screen_state.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:xid/xid.dart';

class TasksBloc extends Bloc<TaskEvent, TaskState> {
  TasksBloc() : super(TasksDummyState()) {
    on<TaskEvent>((event, emit) async {
      Box<TaskModel> hiveBox;

      hiveBox = Hive.box("tasks");

      if (event is TasksInitialEvent) {
        List<TaskModel> taskList = [];

        taskList = hiveBox.values.toList();
        debugPrint("initial state : ${taskList.length}");
        emit(TasksInitialState(taskList: taskList));
      }

      if (event is AddTaskEvent) {
        final task = event.task;
        
        hiveBox.put(Xid().toString(), task);
        
        final taskList = hiveBox.values.toList();

        debugPrint("Successful :: Task added successfully");
        debugPrint("added task in hiveBox : ${hiveBox.values.toList().length}");
        emit(TasksState(taskList: taskList));
      }

      if (event is MarkTaskCompletedEvent) {
        final task = event.task;
        final taskList = hiveBox.values.toList();

        await hiveBox.clear();

        for (var item in taskList) {
          if (item.id != task.id) {
            hiveBox.add(item);
          } else {
            hiveBox.add(task);
          }
        }

      }

      if (event is DeleteTaskEvent) {
        final task = event.task;
        final taskList = hiveBox.values.toList();
        List<TaskModel> updatedList = [];

        for (var item in taskList) {
          // print(item.id + " " + task.id + (item.id == task.id).toString());
          if (item.id != task.id) {
            updatedList.add(item);
          }
        }

        await hiveBox.clear();
        debugPrint("hiveLen : ${hiveBox.values.toList().length}");

        await hiveBox.addAll(updatedList);

        emit(TasksState(taskList: updatedList));
      }
    });
  }
}

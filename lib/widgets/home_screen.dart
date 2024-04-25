import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_bloc.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_event.dart';
import 'package:todo_app/blocs/app_locale_block/app_locale_state.dart';
import 'package:todo_app/blocs/app_theme_block/theme_bloc.dart';
import 'package:todo_app/blocs/app_theme_block/theme_event.dart';
import 'package:todo_app/blocs/app_theme_block/theme_state.dart';
import 'package:todo_app/blocs/home_screen_block/home_screen_bloc.dart';
import 'package:todo_app/blocs/home_screen_block/home_screen_event.dart';
import 'package:todo_app/blocs/home_screen_block/home_screen_state.dart';
import 'package:todo_app/models/locale_model.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/theme_model.dart';
import 'package:todo_app/utils/app_localization.dart';
import 'package:todo_app/utils/common_appbar.dart';
import 'package:todo_app/utils/extensions.dart';
import 'package:todo_app/utils/separator.dart';
import 'package:xid/xid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ThemeBloc>(context).add(InitialThemeEvent());
    BlocProvider.of<AppLocaleBloc>(context).add(AppLocaleChangeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeBloc, ThemeState>(
        bloc: BlocProvider.of<ThemeBloc>(context),
        listener: (_, state) {},
        builder: (context, state) {
          bool isLightTheme = true;
          if (state is AppThemeState) {
            isLightTheme = state.isLightTheme;
          }
          return SafeArea(
            child: Scaffold(
              backgroundColor: isLightTheme
                  ? Colors.white
                  : const Color.fromARGB(255, 50, 49, 49),
              body: Column(
                children: [
                  CommonAppBar(
                    isLightTheme: isLightTheme,
                  ),
                  const Expanded(child: BuildStates()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        foregroundColor: isLightTheme
                            ? null
                            : const Color.fromARGB(255, 170, 168, 168),
                        backgroundColor: isLightTheme
                            ? const Color.fromARGB(255, 170, 168, 168)
                            : const Color.fromARGB(255, 77, 76, 76),
                        onPressed: () {
                          SchedulerBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            showBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return BlocConsumer<ThemeBloc, ThemeState>(
                                    bloc: BlocProvider.of<ThemeBloc>(context),
                                    listener: (_, state) {},
                                    builder: (context, state) {
                                      if (state is AppThemeState) {
                                        return BottomSheetContent(
                                          isLightTheme: state.isLightTheme,
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    });
                              },
                            );
                          });
                        },
                        child: const Icon(
                          Icons.note_alt_outlined,
                        ),
                      ),
                    ],
                  ).padSymmetric(horizontal: 12),
                  24.verticalSpace,
                ],
              ),
            ),
          );
        });
  }
}

class BuildStates extends StatefulWidget {
  const BuildStates({super.key});

  @override
  State<BuildStates> createState() => _BuildStatesState();
}

class _BuildStatesState extends State<BuildStates> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TasksBloc>(context).add(TasksInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TaskState>(
      bloc: BlocProvider.of<TasksBloc>(context),
      listener: (_, state) {},
      builder: (_, state) {
        if (state is TasksInitialState) {
          return BuildTaskList(
            taskList: state.taskList,
          );
        }
        if (state is TasksState) {
          return BuildTaskList(
            taskList: state.taskList,
          );
        }
        // return Text("Initial state");
        return const SizedBox.shrink();
      },
    );
  }
}

// enum HomeScreenTabEnums {
//   tasks,
//   completed,
// }

// extension HomeScreenTabEnumExt on HomeScreenTabEnums {
//   String get getLabel {
//     switch (this) {
//       case HomeScreenTabEnums.tasks:
//         return "Tasks";
//       case HomeScreenTabEnums.completed:
//         return "Completed";
//     }
//   }
// }

// class BuildTabRow extends StatefulWidget {
//   const BuildTabRow({super.key});

//   @override
//   State<BuildTabRow> createState() => _BuildTabRowState();
// }

// class _BuildTabRowState extends State<BuildTabRow>
//     with TickerProviderStateMixin {
//   bool isAllSelected = true;
//   bool isCompletedSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     return TabBar(
//       controller: TabController(length: 2, vsync: this),
//       indicatorColor: Colors.transparent,
//       dividerColor: Colors.black,
//       onTap: (index) {
//         if (index == 0) {
//           setState(() {
//             isAllSelected = true;
//             isCompletedSelected = false;
//           });
//         } else {
//           setState(() {
//             isAllSelected = false;
//             isCompletedSelected = true;
//           });
//         }
//       },
//       tabs: [
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: isAllSelected == true ? Colors.brown : null,
//           ),
//           child: Text(HomeScreenTabEnums.tasks.getLabel).padAll(value: 12),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: isCompletedSelected == true ? Colors.brown : null,
//           ),
//           child: Text(HomeScreenTabEnums.completed.getLabel).padAll(value: 12),
//         ),
//       ],
//     );
//   }
// }

class BottomSheetContent extends StatelessWidget {
  BottomSheetContent({
    super.key,
    required this.isLightTheme,
  });

  final bool isLightTheme;

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLocaleBloc, LocaleState>(
        bloc: BlocProvider.of<AppLocaleBloc>(context),
        listener: (_, state) {},
        builder: (_, state) {
          if (state is AppLocaleState) {
            return Container(
              decoration: BoxDecoration(
                color:
                    isLightTheme ? null : const Color.fromARGB(255, 71, 69, 69),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: textController,
                    maxLines: 3,
                    cursorColor: isLightTheme ? null : Colors.white,
                    style: TextStyle(
                      color: isLightTheme ? null : Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.translate("enter_task_name"),
                      focusColor: null,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(
                        color: isLightTheme ? null : Colors.white,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          final taskName = textController.text.trim();
                          if (taskName.isNotEmpty) {
                            Navigator.of(context).pop();
                            BlocProvider.of<TasksBloc>(context)
                                .add(AddTaskEvent(
                              task: TaskModel(
                                id: Xid().toString(),
                                isCompleted: false,
                                taskName: taskName,
                              ),
                            ));
                          } else {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Flushbar(
                                title: AppLocalizations.translate(
                                    "add_task_err_title"),
                                message: AppLocalizations.translate(
                                    "add_task_err_msg"),
                              );
                            });

                            debugPrint("Error : empty task name");
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isLightTheme
                                ? const Color.fromARGB(255, 170, 168, 168)
                                : const Color.fromARGB(255, 31, 31, 31),
                          ),
                          child: Text(
                            // "Add Task",
                            AppLocalizations.translate("add_task"),
                            style: TextStyle(
                              color: isLightTheme
                                  ? const Color.fromARGB(255, 31, 31, 31)
                                  : const Color.fromARGB(255, 170, 168, 168),
                            ),
                          ).padAll(value: 12),
                        ),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                ],
              ).padSymmetric(horizontal: 12),
            );
          }
          // return Text("bottom sheet locale change");
          return const SizedBox.shrink();
        });
  }
}

class BuildTaskList extends StatelessWidget {
  const BuildTaskList({
    super.key,
    required this.taskList,
  });
  final List<TaskModel> taskList;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: 2 * taskList.length - 1,
          itemBuilder: (_, index) {
            final task = taskList[index ~/ 2];

            if (index % 2 == 0) {
              return BlocConsumer<ThemeBloc, ThemeState>(
                bloc: BlocProvider.of<ThemeBloc>(context),
                listener: (_, state) {},
                builder: (_, state) {
                  if (state is AppThemeState) {
                    return BuildTask(
                      task: task,
                      isLightTheme: state.isLightTheme,
                    ).padSymmetric(horizontal: 12);
                  }
                  // return const Text("Empty build tasks");
                  return const SizedBox.shrink();
                },
              );
            }
            return Row(
              children: [
                Container(
                  height: 2,
                  color: Colors.black,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class BuildTask extends StatefulWidget {
  const BuildTask({
    super.key,
    required this.task,
    required this.isLightTheme,
  });
  final TaskModel task;
  final bool isLightTheme;

  @override
  State<BuildTask> createState() => _BuildTaskState();
}

class _BuildTaskState extends State<BuildTask> {
  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onLeftSwipe: (DragUpdateDetails details) {
        BlocProvider.of<TasksBloc>(context)
            .add(DeleteTaskEvent(task: widget.task));
      },
      leftSwipeWidget: Container(
        decoration: BoxDecoration(
          color: widget.isLightTheme
              ? const Color.fromARGB(255, 170, 168, 168)
              : const Color.fromARGB(255, 31, 31, 31),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.red,
        ).padAll(value: 24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.isLightTheme
              ? const Color.fromARGB(255, 170, 168, 168)
              : const Color.fromARGB(255, 31, 31, 31),
        ),
        child: Row(
          children: [
            Checkbox(
              value: widget.task.isCompleted,
              side: MaterialStateBorderSide.resolveWith(
                (states) => BorderSide(
                  color: widget.isLightTheme ? Colors.black : Colors.white,
                ),
              ),
              checkColor: widget.isLightTheme ? Colors.white : Colors.black,
              fillColor: widget.isLightTheme
                  ? MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.black;
                      }
                      return null;
                    })
                  : MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return null;
                    }),
              onChanged: (value) {
                setState(() {
                  widget.task.isCompleted = value ?? false;
                });

                BlocProvider.of<TasksBloc>(context).add(
                  MarkTaskCompletedEvent(task: widget.task),
                );
              },
            ),
            6.horizontalSpace,
            Text(
              widget.task.taskName,
              style: TextStyle(
                color: widget.isLightTheme ? Colors.black : Colors.white,
              ),
            ),
          ],
        ).padAll(value: 12),
      ),
    );
  }
}

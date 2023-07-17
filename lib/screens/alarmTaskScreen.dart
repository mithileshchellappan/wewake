import 'package:alarm_test/api/task.dart';
import 'package:alarm_test/models/Alarm.dart';
import 'package:alarm_test/models/Task.dart';
import 'package:alarm_test/widgets/taskTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlarmTaskScreen extends StatefulWidget {
  Alarm alarm;
  int memberCount;
  AlarmTaskScreen({super.key, required this.alarm, required this.memberCount});

  @override
  State<AlarmTaskScreen> createState() => _AlarmTaskScreenState();
}

enum UpdateTypes { update, remove, insert }

class _AlarmTaskScreenState extends State<AlarmTaskScreen> {
  List<Task> tasks = [];
  List<FocusNode> _focusNodes = [];
  List<TextEditingController> _textEditingControllers = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setTasks();
  }

  @override
  void dispose() {
    for (var editor in _textEditingControllers) {
      editor.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  void setTasks() async {
    setState(() {
      isLoading = true;
    });
    var res = await getTasks(widget.alarm.AlarmId);
    if (res['success']) {
      tasks = res['tasks'];
      tasks.forEach((_) {
        _focusNodes.add(FocusNode());
        _textEditingControllers.add(TextEditingController());
      });
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Error fetching tasks");
    }
    setState(() {
      tasks = res['tasks'];
      isLoading = false;
    });
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void addTask(Task task, int index) {
    setState(() {
      tasks.removeAt(0);
      tasks.insert(index, task);
    });
  }

  void onUpdate(UpdateTypes upd, int index, Task task) {
    if (upd == UpdateTypes.remove)
      removeTask(index);
    else if (upd == UpdateTypes.insert) addTask(task, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).focusColor,
            onPressed: () {
              setState(() {
                _focusNodes.insert(0, FocusNode());
                _textEditingControllers.insert(0, TextEditingController());
                tasks.insert(
                    0,
                    Task(widget.alarm.AlarmId, "Add your task", false, 0,
                        IsNew: true));
                tasks = List.from(tasks);
              });
            },
            label: const Row(
              children: [
                Icon(CupertinoIcons.add, color: Colors.white),
                Text("Add Task", style: TextStyle(color: Colors.white))
              ],
            )),
        backgroundColor: Colors.black54,
        appBar: CupertinoNavigationBar(
          previousPageTitle: widget.alarm.GroupName,
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).backgroundColor,
          transitionBetweenRoutes: true,
          automaticallyImplyLeading: true,
          middle: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'Tasks',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          trailing: Text(
            widget.alarm.NotificationTitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            child: !isLoading
                ? tasks.length > 0
                    ? ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return TaskTextField(
                            task: tasks[index],
                            groupId: widget.alarm.GroupId!,
                            onUpdate: onUpdate,
                            focusNode: _focusNodes[index],
                            memberCount: widget.memberCount,
                            textEditingController:
                                _textEditingControllers[index],
                            index: index,
                          );
                        },
                      )
                    : const Center(
                        child: Text("No tasks for alarm.",
                            textAlign: TextAlign.center),
                      )
                : Center(
                    child: CupertinoActivityIndicator(),
                  )));
  }
}

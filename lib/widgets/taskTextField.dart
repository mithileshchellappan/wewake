import 'package:alarm_test/api/task.dart';
import 'package:alarm_test/models/Task.dart';
import 'package:alarm_test/widgets/cards/alarmCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskTextField extends StatefulWidget {
  Task task;
  String groupId;
  int index;
  // TasksProvider tasksProvider;
  Function onUpdate;
  FocusNode focusNode;
  TextEditingController textEditingController;
  TaskTextField(
      {super.key,
      required this.task,
      required this.groupId,
      required this.onUpdate,
      // required this.tasksProvider,
      required this.focusNode,
      required this.textEditingController,
      required this.index});

  @override
  State<TaskTextField> createState() => _TaskTextFieldState();
}

class _TaskTextFieldState extends State<TaskTextField> {
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUpdate(_) async {
    if (widget.textEditingController.text.isEmpty) {
      widget.onUpdate(UpdateTypes.remove, widget.index, widget.task);
    } else {
      widget.task.TaskText = widget.textEditingController.text;
      if (widget.task.IsNew) {
        var res = await createTask(widget.groupId, widget.task);
        if (res['success']) {
          widget.task = res['task'];

          setState(() {
            isEdit = false;
            widget.task.IsNew = false;
          });
          widget.onUpdate(UpdateTypes.insert, widget.index, res['task']);
        } else {
          setState(() {
            isEdit = false;
            widget.task.IsNew = false;
          });
          widget.onUpdate(UpdateTypes.remove, widget.index, widget.task);

          Fluttertoast.showToast(msg: "Error creating task");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            widget.task.IsDone = !widget.task.IsDone;
          });
        },
        onLongPress: () {
          // _controller.
          widget.focusNode.requestFocus();
          setState(() {
            isEdit = true;
            widget.textEditingController.text = widget.task.TaskText;
          });
        },
        child: Container(
            height: widget.task.IsDone ? 25 : 30,
            // margin: const EdgeInsets.only(bottom: 3.0, top: 2.0),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(
                bottom: BorderSide(
                  width: 0.4,
                  color: Colors.grey,
                ),
              ),
            ),
            child: (isEdit || widget.task.IsNew)
                ? CupertinoTextField.borderless(
                    cursorHeight: 16,
                    autocorrect: true,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    controller: widget.textEditingController,
                    focusNode: widget.focusNode,
                    textAlign: TextAlign.center,
                    maxLength: 20,
                    style: TextStyle(
                        color:
                            widget.task.IsDone ? Colors.white54 : Colors.white,
                        fontSize: 16),
                    onTapOutside: setUpdate,
                    onSubmitted: setUpdate,
                  )
                : Row(
                    children: [
                      SizedBox(
                          width: 5,
                          child: Container(
                            color: Colors.black,
                          )),
                      Text(
                        widget.task.TaskText,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: widget.task.IsDone ? 14 : 18,
                            decoration: widget.task.IsDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        "12/18",
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  )));
  }
}

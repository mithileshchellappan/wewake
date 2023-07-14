import 'package:alarm_test/api/task.dart';
import 'package:alarm_test/models/Task.dart';
import 'package:alarm_test/screens/alarmTaskScreen.dart';
import 'package:alarm_test/widgets/cards/alarmCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskTextField extends StatefulWidget {
  Task task;
  String groupId;
  int index;
  int memberCount;
  Function onUpdate;
  FocusNode focusNode;
  TextEditingController textEditingController;
  TaskTextField(
      {super.key,
      required this.task,
      required this.groupId,
      required this.onUpdate,
      required this.focusNode,
      required this.memberCount,
      required this.textEditingController,
      required this.index});

  @override
  State<TaskTextField> createState() => _TaskTextFieldState();
}

class _TaskTextFieldState extends State<TaskTextField> {
  bool _isEdit = false;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUpdate(_) async {
    print("here");
    if (widget.textEditingController.text.isEmpty) {
      widget.onUpdate(UpdateTypes.remove, widget.index, widget.task);
    } else {
      widget.task.TaskText = widget.textEditingController.text;
      if (widget.task.IsNew) {
        var res = await createTask(widget.groupId, widget.task);
        if (res['success']) {
          widget.task = res['task'];

          setState(() {
            _isEdit = false;
            widget.task.IsNew = false;
          });
          widget.onUpdate(UpdateTypes.insert, widget.index, res['task']);
        } else {
          setState(() {
            _isEdit = false;
            widget.task.IsNew = false;
          });
          widget.onUpdate(UpdateTypes.remove, widget.index, widget.task);

          Fluttertoast.showToast(msg: "Error creating task");
        }
      } else {
        setState(() {
          _isEdit = false;
          widget.task.IsNew = false;
        });
      }
    }
  }

  void setDone() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      var res =
          await setTaskStatus(widget.task.AlarmTaskId, widget.task.IsDone);
      if (!res['success']) {
        setState(() {
          widget.task.IsDone = !widget.task.IsDone;
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "Error setting task status");
      } else {
        setState(() {
          widget.task.IsDone
              ? ++widget.task.DoneCount
              : --widget.task.DoneCount;
          _isLoading = false;
        });
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
          setDone();
        },
        onLongPress: () {
          // _controller.
          widget.focusNode.requestFocus();
          setState(() {
            _isEdit = true;
            widget.textEditingController.text = widget.task.TaskText;
          });
        },
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: widget.task.IsDone ? 35 : 40,
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
            child: (_isEdit || widget.task.IsNew)
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
                        fontSize: 15),
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
                            fontSize: widget.task.IsDone ? 18 : 20,
                            decoration: widget.task.IsDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      SizedBox(
                          width: 5,
                          child: Container(
                            color: Colors.black,
                          )),
                      _isLoading ? CupertinoActivityIndicator() : Container(),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        "${widget.task.DoneCount}/${widget.memberCount}",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  )));
  }
}

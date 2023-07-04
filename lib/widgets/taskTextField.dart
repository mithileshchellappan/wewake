import 'package:alarm_test/models/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskTextField extends StatefulWidget {
  Task task;
  TaskTextField({super.key, required this.task});

  @override
  State<TaskTextField> createState() => _TaskTextFieldState();
}

class _TaskTextFieldState extends State<TaskTextField> {
  TextEditingController _controller = TextEditingController();
  bool isEdit = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // focusNode = FocusNode();
  }

  void setUpdate(_) {
    setState(() {
      isEdit = false;
      widget.task.TaskText = _controller.text;
      widget.task.IsNew = false;
    });
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
          focusNode.requestFocus();
          setState(() {
            isEdit = true;
            _controller.text = widget.task.TaskText;
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
                    controller: _controller,
                    focusNode: focusNode,
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

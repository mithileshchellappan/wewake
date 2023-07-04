import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  List<String> tasks = [];
  TaskList({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) => Container(
          color: Colors.black,
          width: constraints.maxWidth,
          height: (29 * tasks.length).toDouble(),
          child: Column(
              children: tasks
                  .map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 3.0, top: 2.0),
                        child: Container(
                          width: constraints.maxWidth,
                          height: 24,
                          child: TaskTextField(text: task),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 0.3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList()))),
    );
  }
}

class TaskTextField extends StatefulWidget {
  String text;
  TaskTextField({
    super.key,
    required this.text,
  });

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          // _controller.
          focusNode.requestFocus();
          setState(() {
            isEdit = true;
            _controller.text = widget.text;
          });
        },
        child: isEdit
            ? CupertinoTextField.borderless(
                cursorHeight: 10,
                autocorrect: true,
                autofocus: true,
                keyboardType: TextInputType.text,
                controller: _controller,
                focusNode: focusNode,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
                onTapOutside: (_) {
                  setState(() {
                    isEdit = false;
                    widget.text = _controller.text;
                  });
                },
                onSubmitted: (value) => {
                  setState(() {
                    isEdit = false;
                    widget.text = _controller.text;
                  })
                },
              )
            : Row(
                children: [
                  SizedBox(width: 5),
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "12/18",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ));
  }
}

class Task {
  late String AlarmTaskId = "";
  late String AlarmId;
  late String TaskText;
  late bool IsDone;
  late int DoneCount;
  bool IsNew = false;

  Task(this.AlarmId, this.TaskText, this.IsDone, this.DoneCount,
      {this.IsNew = false});

  Task.fromJson(dynamic json) {
    AlarmTaskId = json["alarmTaskId"];
    AlarmId = json["alarmId"];
    TaskText = json["taskText"];
    IsDone = json["isDone"];
    DoneCount = json["doneCount"];
    IsNew = false;
  }

  Map<String, dynamic> toJson(String groupId) => {
        'GroupId': groupId,
        'AlarmId': AlarmId,
        'TaskText': TaskText,
      };

  static List<Task> fromListJson(List<dynamic> arr) {
    List<Task> tasks = [];
    for (var json in arr) {
      Task task = Task.fromJson(json);
      tasks.add(task);
    }

    return tasks;
  }
}

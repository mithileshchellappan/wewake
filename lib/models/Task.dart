class Task {
  late String TaskId;
  late String AlarmId;
  late String TaskText;
  late bool IsDone;
  bool IsNew;

  Task(this.AlarmId, this.TaskText, this.IsDone, {this.IsNew = false});
}

/// Define schedule display duration in a day.
class AppSettings {
  int duration;
  int leadtime;
  int clockStart;
  int clockEnd;
  String remark;

  AppSettings(
      {this.duration = 15,
      this.leadtime = 15,
      this.clockStart = 8,
      this.clockEnd = 20,
      this.remark = ""});
}

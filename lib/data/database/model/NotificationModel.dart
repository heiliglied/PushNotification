class NotificationModel {
  final int? id;
  final DateTime date;
  final String title;
  final String contents;
  final String sound;
  final bool alarm;
  final bool status;

  NotificationModel({
    this.id,
    required this.date,
    required this.title,
    required this.contents,
    required this.sound,
    required this.alarm,
    required this.status,
  });

  // JSON → Model
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      contents: json['contents'],
      sound: json['sound'],
      alarm: json['alarm'],
      status: json['status'],
    );
  }

  // Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'contents': contents,
      'sound': sound,
      'alarm': alarm,
      'status': status,
    };
  }
}
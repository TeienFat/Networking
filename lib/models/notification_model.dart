class Notifications {
  String? notiId;
  String? userId;
  String? title;
  String? body;
  String? contentBody;
  String? usReImage;
  String? payload;
  int? status;
  DateTime? period;

  Notifications({
    required this.notiId,
    required this.userId,
    required this.title,
    required this.body,
    required this.contentBody,
    required this.usReImage,
    required this.payload,
    required this.status,
    required this.period,
  });

  Notifications.fromMap(Map<String, dynamic> map) {
    notiId = map['notiId'];
    userId = map['userId'];
    title = map['title'];
    body = map['body'];
    contentBody = map['contentBody'];
    usReImage = map['usReImage'];
    payload = map['payload'];
    status = map['status'];
    period = DateTime.parse(map['period']);
  }
  Map<String, dynamic> toMap() {
    return ({
      "notiId": notiId,
      "userId": userId,
      "title": title,
      "body": body,
      "contentBody": contentBody,
      "usReImage": usReImage,
      "payload": payload,
      "status": status,
      "period": period!.toIso8601String(),
    });
  }
}

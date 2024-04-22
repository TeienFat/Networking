class RelationshipCare {
  String? reCareId;
  String? meId;
  String? usReId;
  DateTime? startTime;
  DateTime? endTime;
  String? title;
  String? contentText;
  List<dynamic>? contentImage;
  int? isFinish;
  DateTime? createdAt;
  DateTime? updateAt;
  DateTime? deleteAt;

  RelationshipCare({
    required this.reCareId,
    required this.meId,
    required this.usReId,
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.contentText,
    required this.contentImage,
    required this.isFinish,
    required this.createdAt,
    required this.updateAt,
    required this.deleteAt,
  });

  RelationshipCare.fromMap(Map<String, dynamic> map) {
    reCareId = map['ReCare'];
    meId = map['meId'];
    usReId = map['usReId'];
    startTime = DateTime.parse(map['startTime']);
    endTime = DateTime.parse(map['endTime']);
    title = map['title'];
    contentText = map['contentText'];
    contentImage = map['contentImage'];
    isFinish = map['isFinish'];
    createdAt = DateTime.parse(map['createdAt']);
    updateAt = map['updateAt'] != null ? DateTime.parse(map['updateAt']) : null;
    deleteAt = map['deleteAt'] != null ? DateTime.parse(map['deleteAt']) : null;
  }
  Map<String, dynamic> toMap() {
    return ({
      "ReCare": reCareId,
      "meId": meId,
      "usReId": usReId,
      "startTime": startTime!.toIso8601String(),
      "endTime": endTime!.toIso8601String(),
      "title": title,
      "contentText": contentText,
      "contentImage": contentImage,
      "isFinish": isFinish,
      "createdAt": createdAt!.toIso8601String(),
      "updateAt": updateAt != null ? updateAt!.toIso8601String() : null,
      "deleteAt": deleteAt != null ? deleteAt!.toIso8601String() : null,
    });
  }
}

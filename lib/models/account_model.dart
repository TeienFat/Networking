class Account {
  String? loginName;
  String? userId;
  String? email;
  String? password;
  String? question;
  String? answer;
  DateTime? createdAt;
  DateTime? updateAt;
  DateTime? deleteAt;

  Account({
    required this.loginName,
    required this.userId,
    required this.email,
    required this.password,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updateAt,
    required this.deleteAt,
  });

  Account.fromMap(Map<String, dynamic> map) {
    loginName = map['loginName'];
    userId = map['userId'];
    email = map['email'];
    password = map['password'];
    question = map['question'];
    answer = map['answer'];
    createdAt = DateTime.parse(map['createdAt']);
    updateAt = map['updateAt'] != null ? DateTime.parse(map['updateAt']) : null;
    deleteAt = map['deleteAt'] != null ? DateTime.parse(map['deleteAt']) : null;
  }
  Map<String, dynamic> toMap() {
    return ({
      "loginName": loginName,
      "userId": userId,
      "email": email,
      "password": password,
      "question": question,
      "answer": answer,
      "createdAt": createdAt!.toIso8601String(),
      "updateAt": updateAt != null ? updateAt!.toIso8601String() : null,
      "deleteAt": deleteAt != null ? deleteAt!.toIso8601String() : null,
    });
  }

  // static String encode(List<Account> accounts) => json.encode(
  //       accounts
  //           .map<Map<String, dynamic>>((account) => account.toMap())
  //           .toList(),
  //     );

  // static List<Account> decode(String accounts) =>
  //     (json.decode(accounts) as List<dynamic>)
  //         .map<Account>((item) => Account.fromMap(item))
  //         .toList();
}

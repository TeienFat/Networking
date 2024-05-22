import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/main.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';

class APIsChatBot {
  static String getInfoFromUser(Users user) {
    final gender = user.gender! ? "Nữ" : "Nam";
    String address = '';
    String otherInfo = '';
    for (var element in user.address!) {
      address += element.name! +
          " " +
          element.street! +
          " " +
          element.wards!['name'] +
          " " +
          element.district!['name'] +
          " " +
          element.province!['name'] +
          ", ";
    }
    user.otherInfo!.forEach(
      (key, value) {
        otherInfo += "\n-" + key + ": " + value;
      },
    );
    return "\nHọ tên: ${user.userName}" +
        "\nGiới tính: $gender" +
        "\nNgày sinh: ${user.birthday}" +
        "\nĐịa chỉ: $address" +
        "\nSở thích: ${user.hobby}" +
        "\nSố điện thoại: ${user.phone}" +
        "\nEmail: ${user.email}" +
        "\nThông tin khác: $otherInfo";
  }

  static Future<String> getAllRecareInfo(String usReId) async {
    String result = '';
    List<RelationshipCare> reCares =
        await APIsReCare.getAllMyRelationshipCare();
    final myReCare =
        reCares.where((element) => element.usReId == usReId).toList();
    for (var element in myReCare) {
      if (element.isFinish == 1) {
        result += "\n-Nội dung: " + element.title! + " " + element.contentText!;
      }
    }
    return "\nNhững lần tôi đã chăm sóc cho mối quan hệ này: " + result;
  }

  static Future<String> getAllUsReInfo() async {
    String result = '';
    List<UserRelationship> usRes = await APIsUsRe.getAllMyRelationship();
    for (var i = 0; i < usRes.length; i++) {
      var user = await APIsUser.getUserFromId(usRes[i].myRelationShipId!);
      result += "\n+Mối quan hệ thứ ${i + 1}: " + getInfoFromUser(user!);
      result += "\n-Quan hệ tôi và mối quan hệ này: ";
      if (usRes[i].special!)
        result += "\n-Tôi cần chăm sóc đặc biệt cho mối quan hệ này";
      for (var element in usRes[i].relationships!) {
        result += element.name! + ", ";
      }
      result += await getAllRecareInfo(usRes[i].usReId!);
    }
    return "\nDưới đây là thông tin về các mối quan hệ của tôi: " + result;
  }

  static Future<String> getDataForChatBot() async {
    String data = '';
    final myInfo = await APIsUser.getUserFromId(currentUserId);
    data += "Dưới đây là thông tin của tôi: " + getInfoFromUser(myInfo!);
    data += await getAllUsReInfo();
    print(data);
    return data;
  }
}

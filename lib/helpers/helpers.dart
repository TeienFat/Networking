import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:networking/models/relationship_model.dart';

Widget searchBar(Function filter, double width) {
  return Container(
    width: width,
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
          offset: const Offset(12, 26),
          blurRadius: 50,
          spreadRadius: 0,
          color: const Color.fromRGBO(158, 158, 158, 1).withOpacity(.3)),
    ]),
    child: TextField(
      onChanged: (value) => filter(value),
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Color.fromRGBO(247, 247, 252, 1),
        hintText: 'Tìm kiếm',
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    ),
  );
}

class MyDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch((int.parse(time)));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final sent = DateTime.fromMillisecondsSinceEpoch((int.parse(time)));
    final now = DateTime.now();
    if (sent.day == now.day &&
        sent.month == now.month &&
        sent.year == now.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    if (sent.day != now.day &&
        sent.weekOfMonth == now.weekOfMonth &&
        sent.month == now.month &&
        sent.year == now.year) {
      return getFormattedWeekday(sent);
    }
    return '${sent.day} thg ${sent.month}';
  }

  static String getFormattedWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Th 2';
      case 2:
        return 'Th 3';
      case 3:
        return 'Th 4';
      case 4:
        return 'Th 5';
      case 5:
        return 'Th 6';
      case 6:
        return 'Th 7';
      case 7:
        return 'CN';
    }
    return 'NA';
  }
}

extension DateTimeExtension on DateTime {
  int get weekOfMonth {
    var date = this;
    final firstDayOfTheMonth = DateTime(date.year, date.month, 1);
    int sum = firstDayOfTheMonth.weekday - 1 + date.day;
    if (sum % 7 == 0) {
      return sum ~/ 7;
    } else {
      return sum ~/ 7 + 1;
    }
  }
}

Widget getRowDateTime(DateTime dateTime) {
  return Row(
    children: [
      Icon(
        FontAwesomeIcons.solidClock,
        size: 12.sp,
      ),
      SizedBox(
        width: 3.sp,
      ),
      Text(DateFormat("HH:mm").format(dateTime)),
      SizedBox(
        width: 10.sp,
      ),
      Icon(
        FontAwesomeIcons.calendar,
        size: 12.sp,
      ),
      SizedBox(
        width: 3.sp,
      ),
      Text(MyDateUtil.getFormattedWeekday(dateTime)),
      SizedBox(
        width: 3.sp,
      ),
      Text(DateFormat("- d' thg 'M', 'yyyy'").format(dateTime)),
    ],
  );
}

String calculateTimeRange(DateTime startDate) {
  DateTime currentDate = DateTime.now();
  Duration timeRange = currentDate.difference(startDate);

  if (timeRange.inDays == 0) {
    return 'Hôm nay';
  } else if (timeRange.inDays == 1) {
    return 'Hôm qua';
  } else if (timeRange.inDays < 7) {
    return '${timeRange.inDays} ngày trước';
  } else if (timeRange.inDays < 30) {
    int weeks = (timeRange.inDays / 7).floor();
    return '$weeks tuần trước';
  } else if (timeRange.inDays < 365) {
    int months = (timeRange.inDays / 30).floor();
    return '$months tháng trước';
  } else {
    int years = (timeRange.inDays / 365).floor();
    return '$years năm trước';
  }
}

void toast(String content) {
  Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showSnackbar(BuildContext context, String content, Duration duration,
    bool type, double top,
    {String? subtitle, ElevatedButton? button}) {
  final snackBar = SnackBar(
    margin: EdgeInsets.only(
      bottom: top,
      left: 70.sp,
      right: 10.sp,
    ),
    content: Row(
      children: [
        type
            ? Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
              )
            : Icon(
                Icons.error_outlined,
                color: Colors.red,
              ),
        SizedBox(width: 10.sp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: subtitle != null ? 5.sp : 0),
            subtitle != null
                ? type
                    ? Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11.sp,
                        ),
                      )
                    : Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11.sp,
                        ),
                      )
                : SizedBox(),
          ],
        ),
        Spacer(),
        button != null ? button : SizedBox(),
      ],
    ),
    duration: duration,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Color.fromARGB(170, 0, 0, 0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.sp),
    ),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

FaIcon showRelationshipTypeIcon(int type, double iconSize) {
  switch (type) {
    case 0:
      return FaIcon(
        FontAwesomeIcons.houseUser,
        size: iconSize,
      );
    case 1:
      return FaIcon(
        FontAwesomeIcons.heart,
        size: iconSize,
      );

    case 2:
      return FaIcon(
        FontAwesomeIcons.briefcase,
        size: iconSize,
      );

    case 3:
      return FaIcon(
        FontAwesomeIcons.userGroup,
        size: iconSize,
      );

    default:
      return FaIcon(
        FontAwesomeIcons.bookOpenReader,
        size: iconSize,
      );
  }
}

FaIcon showAddressTypeIcon(int type, double iconSize) {
  switch (type) {
    case 0:
      return FaIcon(
        FontAwesomeIcons.house,
        size: iconSize,
      );
    case 1:
      return FaIcon(
        FontAwesomeIcons.building,
        size: iconSize,
      );
    case 2:
      return FaIcon(
        FontAwesomeIcons.school,
        size: iconSize,
      );
    default:
      return FaIcon(
        FontAwesomeIcons.mapSigns,
        size: iconSize,
      );
  }
}

String showAddressTypeText(int type) {
  switch (type) {
    case 0:
      return "Nhà";
    case 1:
      return "Công ty";
    case 2:
      return "Trường học";
    default:
      return "Khác";
  }
}

Widget hr = Divider(
  color: Colors.grey[300],
  thickness: 1.5.sp,
);

List<Widget> getRowRelationship(List<Relationship> relationships, int num,
    double fontSize, double iconSize) {
  List<Widget> list = [];
  FaIcon icon;
  int numCheck = 0;
  for (var element in relationships) {
    if (numCheck != num) {
      icon = showRelationshipTypeIcon(element.type!, iconSize);
      list.add(Row(
        children: [
          icon,
          SizedBox(
            width: 5.sp,
          ),
          Text(
            element.name!,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            width: 15.sp,
          ),
        ],
      ));
      numCheck++;
    }
  }
  return list;
}

List<Widget> getAllRowRelationship(List<Relationship> relationships,
    double fontSize, double iconSize, double width) {
  List<Widget> list = [];

  list = relationships
      .map((e) => Row(
            children: [
              Container(
                  width: 41.sp,
                  child: showRelationshipTypeIcon(e.type!, iconSize)),
              // SizedBox(
              //   width: width,
              // ),
              Text(
                e.name!,
                style: TextStyle(
                    fontSize: fontSize, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                width: 15.sp,
              ),
            ],
          ))
      .toList();

  return list;
}

void showMyDialog(
    BuildContext context,
    String title,
    String content,
    String cancleButtonName,
    String confirmButtonName,
    Set<Function> confirmFunction) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.grey)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(cancleButtonName),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red)),
          onPressed: () => confirmFunction,
          child: Text(confirmButtonName),
        ),
      ],
    ),
  );
}

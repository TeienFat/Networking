import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MutiSwicthButton extends StatefulWidget {
  const MutiSwicthButton(
      {super.key, required this.onSelectLong, required this.intLong});
  final Function(int long) onSelectLong;
  final int intLong;
  @override
  State<MutiSwicthButton> createState() => _MutiSwicthButtonState();
}

class _MutiSwicthButtonState extends State<MutiSwicthButton> {
  var _long;
  void _onSelectLong(int long) {
    setState(() {
      _long = long;
      widget.onSelectLong(long);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _long = widget.intLong;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.sp,
      width: ScreenUtil().screenWidth - 20.sp,
      decoration: BoxDecoration(
          color: Colors.grey[400]!,
          borderRadius: BorderRadius.all(Radius.circular(30.sp))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        TextButton(
            onPressed: () {
              _onSelectLong(1);
            },
            child: Text(
              "1 ngày",
              style: TextStyle(fontWeight: _long == 1 ? FontWeight.bold : null),
            ),
            style: ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 16.sp, horizontal: 18.sp)),
                backgroundColor: _long == 1
                    ? MaterialStatePropertyAll(Colors.orange[600]!)
                    : null)),
        TextButton(
            onPressed: () {
              _onSelectLong(2);
            },
            child: Text(
              "1 tuần",
              style: TextStyle(fontWeight: _long == 2 ? FontWeight.bold : null),
            ),
            style: ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 16.sp, horizontal: 18.sp)),
                backgroundColor: _long == 2
                    ? MaterialStatePropertyAll(Colors.orange[600]!)
                    : null)),
        TextButton(
            onPressed: () {
              _onSelectLong(3);
            },
            child: Text(
              "1 tháng",
              style: TextStyle(fontWeight: _long == 3 ? FontWeight.bold : null),
            ),
            style: ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 16.sp, horizontal: 18.sp)),
                backgroundColor: _long == 3
                    ? MaterialStatePropertyAll(Colors.orange[600]!)
                    : null)),
        TextButton(
            onPressed: () {
              _onSelectLong(4);
            },
            child: Text(
              "1 năm",
              style: TextStyle(fontWeight: _long == 4 ? FontWeight.bold : null),
            ),
            style: ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 16.sp, horizontal: 18.sp)),
                backgroundColor: _long == 4
                    ? MaterialStatePropertyAll(Colors.orange[600]!)
                    : null)),
      ]),
    );
  }
}

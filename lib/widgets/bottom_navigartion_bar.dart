import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyBottomNavigartionBar extends StatefulWidget {
  const MyBottomNavigartionBar(
      {super.key,
      required this.currentIndex,
      required this.onTapIcon,
      required this.onTapAdd});
  final int currentIndex;
  final Function(int index) onTapIcon;
  final Function(int index) onTapAdd;
  @override
  State<MyBottomNavigartionBar> createState() => _MyBottomNavigartionBarState();
}

class _MyBottomNavigartionBarState extends State<MyBottomNavigartionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.sp),
          topRight: Radius.circular(15.sp),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      height: 60.sp,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                widget.currentIndex == 0 ? Colors.grey[300] : null,
              )),
              icon: Icon(
                Icons.home_outlined,
                size: 30.sp,
                color:
                    widget.currentIndex == 0 ? Colors.orange[600] : Colors.grey,
              ),
              onPressed: () => widget.onTapIcon(0),
            ),
            IconButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                widget.currentIndex == 1 ? Colors.grey[300] : null,
              )),
              icon: Icon(
                FontAwesomeIcons.handshake,
                size: 25,
                color:
                    widget.currentIndex == 1 ? Colors.orange[600] : Colors.grey,
              ),
              onPressed: () => widget.onTapIcon(1),
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.add_circle_rounded,
                color: Colors.orange[600],
                size: 60.sp,
              ),
              onPressed: () => widget.onTapAdd(widget.currentIndex),
            ),
            IconButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                widget.currentIndex == 2 ? Colors.grey[300] : null,
              )),
              icon: Icon(
                Icons.chat_outlined,
                size: 25.sp,
                color:
                    widget.currentIndex == 2 ? Colors.orange[600] : Colors.grey,
              ),
              onPressed: () => widget.onTapIcon(2),
            ),
            IconButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                widget.currentIndex == 3 ? Colors.grey[300] : null,
              )),
              icon: Icon(
                Icons.person_outline_sharp,
                size: 35,
                color:
                    widget.currentIndex == 3 ? Colors.orange[600] : Colors.grey,
              ),
              onPressed: () => widget.onTapIcon(3),
            ),
          ],
        ),
      ),
    );
  }
}

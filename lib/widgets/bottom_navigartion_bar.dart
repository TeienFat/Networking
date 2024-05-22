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
    return SizedBox(
      height: 75.sp,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 70.sp,
                height: 70.sp,
                padding: EdgeInsets.only(top: 7.sp),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 255, 204, 146),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.sp),
                    topRight: Radius.circular(20.sp),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 255, 204, 146),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                height: 60.sp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        Icons.home_outlined,
                        size: 30.sp,
                        color: widget.currentIndex == 0
                            ? Colors.orange[600]
                            : Colors.grey,
                      ),
                      onPressed: () => widget.onTapIcon(0),
                    ),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        FontAwesomeIcons.handshake,
                        size: 25,
                        color: widget.currentIndex == 1
                            ? Colors.orange[600]
                            : Colors.grey,
                      ),
                      onPressed: () => widget.onTapIcon(1),
                    ),
                    SizedBox(
                      width: 50.sp,
                    ),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        Icons.chat_outlined,
                        size: 25.sp,
                        color: widget.currentIndex == 2
                            ? Colors.orange[600]
                            : Colors.grey,
                      ),
                      onPressed: () => widget.onTapIcon(2),
                    ),
                    IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        Icons.person_outline_sharp,
                        size: 35,
                        color: widget.currentIndex == 3
                            ? Colors.orange[600]
                            : Colors.grey,
                      ),
                      onPressed: () => widget.onTapIcon(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 70.sp,
                height: 70.sp,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: widget.currentIndex != 3
                    ? IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: Colors.orange[600],
                          size: 65.sp,
                        ),
                        onPressed: () => widget.onTapAdd(widget.currentIndex),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.orange[600]),
                        margin: EdgeInsets.only(left: 8.sp, right: 8.sp),
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                          onPressed: () => widget.onTapAdd(widget.currentIndex),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

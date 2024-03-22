import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      height: 98.sp,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.sp),
                  topRight: Radius.circular(25.sp),
                ),
              ),
              padding: EdgeInsets.all(10.sp),
              height: 60.sp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    width: ScreenUtil().screenWidth / 3,
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
                            color: widget.currentIndex == 0
                                ? Colors.orange[600]
                                : Colors.grey,
                          ),
                          onPressed: () => widget.onTapIcon(0),
                        ),
                        IconButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            widget.currentIndex == 1 ? Colors.grey[300] : null,
                          )),
                          icon: Icon(
                            Icons.handshake_outlined,
                            size: 30,
                            color: widget.currentIndex == 1
                                ? Colors.orange[600]
                                : Colors.grey,
                          ),
                          onPressed: () => widget.onTapIcon(1),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ScreenUtil().screenWidth / 3,
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            widget.currentIndex == 2 ? Colors.grey[300] : null,
                          )),
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
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            widget.currentIndex == 3 ? Colors.grey[300] : null,
                          )),
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
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: Colors.orange[600],
                  size: 75.sp,
                ),
                onPressed: () => widget.onTapAdd(widget.currentIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

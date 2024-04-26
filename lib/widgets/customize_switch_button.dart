import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColorLeft;
  final Color buttonColorRight;
  final Color textColor;
  final double buttonHeight;
  final double buttonWidth;
  final bool initValue;

  MyAnimatedToggle(
      {required this.values,
      required this.onToggleCallback,
      this.backgroundColor = const Color(0xFFe7e7e8),
      this.buttonColorLeft = const Color(0xFFFFFFFF),
      this.buttonColorRight = const Color(0xFFFFFFFF),
      this.textColor = const Color(0xFF000000),
      this.buttonHeight = 80,
      this.buttonWidth = 300,
      this.initValue = true});
  @override
  _MyAnimatedToggleState createState() => _MyAnimatedToggleState();
}

class _MyAnimatedToggleState extends State<MyAnimatedToggle> {
  var _enteredValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _enteredValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.sp,
      ),
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _enteredValue = !_enteredValue;
              widget.onToggleCallback(_enteredValue);
              setState(() {});
            },
            child: Container(
              width: widget.buttonWidth,
              height: widget.buttonHeight,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      widget.values[index],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                _enteredValue ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: widget.buttonWidth * 0.5,
              height: widget.buttonHeight,
              decoration: ShapeDecoration(
                color: _enteredValue
                    ? widget.buttonColorLeft
                    : widget.buttonColorRight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                _enteredValue ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}

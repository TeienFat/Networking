import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/widgets/customize_switch_button.dart';

class EvaluateReCare extends StatefulWidget {
  const EvaluateReCare(
      {super.key, required this.onEvaluate, this.initIsSuccess = true});
  final bool initIsSuccess;
  final Function(bool isSuccess) onEvaluate;

  @override
  State<EvaluateReCare> createState() => _EvaluateReCareState();
}

class _EvaluateReCareState extends State<EvaluateReCare> {
  var _isSuccess;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isSuccess = widget.initIsSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight / 5.5,
          child: Padding(
              padding: EdgeInsets.only(top: 10.sp),
              child: Column(
                children: [
                  MyAnimatedToggle(
                    values: ['Hoàn thành', 'Không hoàn thành'],
                    onToggleCallback: (value) {
                      _isSuccess = value;
                    },
                    buttonColorLeft: Colors.green,
                    buttonColorRight: Colors.redAccent,
                    backgroundColor: Colors.grey[400]!,
                    textColor: Colors.black,
                    buttonHeight: 60.sp,
                    buttonWidth: ScreenUtil().screenWidth,
                    initValue: _isSuccess,
                  ),
                  hr,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Hủy",
                            style: TextStyle(color: Colors.grey),
                          )),
                      TextButton(
                          onPressed: () {
                            widget.onEvaluate(_isSuccess);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Xác nhận",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              )),
        );
      },
    );
  }
}

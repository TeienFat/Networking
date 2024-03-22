import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.loginName});
  final String loginName;
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

final _formKey = GlobalKey<FormState>();
var _enteredPassword = '';
final Color _color = Color.fromARGB(255, 133, 129, 99);
var _isDone = false;

class _ResetPasswordState extends State<ResetPassword> {
  void _submit(BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    APIsAuth.resetPassword(widget.loginName, _enteredPassword);
    setState(() {
      _isDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(top: 0, bottom: 10.sp, left: 10.sp, right: 10.sp),
          child: !_isDone
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/reset-password.png",
                        ),
                      ),
                      Text(
                        'Đặt lại mật khẩu',
                        style: TextStyle(
                            color: _color,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: TextStyle(fontSize: 16.sp),
                              decoration: InputDecoration(
                                hintText: "Mật khẩu",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Mật khẩu phải có độ dài ít nhất 6 kí tự.";
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                _enteredPassword = value;
                              },
                              onChanged: (value) {
                                _enteredPassword = value;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!.trim();
                              },
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                            ),
                            SizedBox(
                              height: 20.sp,
                            ),
                            TextFormField(
                              style: TextStyle(fontSize: 16.sp),
                              decoration: InputDecoration(
                                hintText: "Nhập lại mật khẩu",
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value != _enteredPassword) {
                                  return "Nhập lại mật khẩu không đúng.";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.save();
                            _submit(context);
                          },
                          child: Text(
                            "Đặt lại mật khẩu",
                            style: TextStyle(
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 100.sp),
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(70, 76, 175, 79),
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.done_all_rounded,
                          color: Colors.green,
                          size: 150.sp,
                        ),
                      ),
                      SizedBox(
                        height: 50.sp,
                      ),
                      Text(
                        "Mật khẩu mới đã được thay đổi",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        width: 250.sp,
                        child: Text(
                          "Bạn đã đặt lại mật khẩu thành công. Hãy sử dụng mật khẩu mới của bạn khi đăng nhập.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                          padding: MaterialStatePropertyAll(
                            EdgeInsetsDirectional.symmetric(
                                horizontal: 100.sp, vertical: 15.sp),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.of(context).pushReplacementNamed("/Auth"),
                        child: Text(
                          "Quay lại đăng nhập",
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

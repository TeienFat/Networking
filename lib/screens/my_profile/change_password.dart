import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/helpers/helpers.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.loginName});
  final String loginName;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

final _formKey = GlobalKey<FormState>();
var _enteredPassword;
var _enteredOldPassword;
final Color _color = Color.fromARGB(255, 133, 129, 99);

class _ChangePasswordState extends State<ChangePassword> {
  void _submit(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    final checkPassword =
        await APIsAuth.checkPassword(widget.loginName, _enteredOldPassword);
    if (!isValid) {
      return;
    }
    if (checkPassword) {
      APIsAuth.resetPassword(widget.loginName, _enteredPassword);
      showSnackbar(
          context, "Đổi mật khẩu thành công", Duration(seconds: 2), true);
      Navigator.of(context).pop();
    } else {
      showSnackbar(
          context, "Mật khẩu hiện tại không đúng", Duration(seconds: 2), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
                top: 0, bottom: 10.sp, left: 10.sp, right: 10.sp),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/reset-password.png",
                    ),
                  ),
                  Text(
                    'Đổi mật khẩu',
                    style: TextStyle(
                        color: _color,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: TextStyle(fontSize: 16.sp),
                          decoration: InputDecoration(
                            hintText: "Mật khẩu hiện tại",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return "Mật khẩu phải có độ dài ít nhất 6 kí tự.";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            _enteredOldPassword = value;
                          },
                          onChanged: (value) {
                            _enteredOldPassword = value;
                          },
                          onSaved: (value) {
                            _enteredOldPassword = value!.trim();
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
                            hintText: "Mật khẩu mới",
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
                            hintText: "Nhập lại mật khẩu mới",
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
                    height: 10.sp,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        _submit(context);
                      },
                      child: Text(
                        "Đổi mật khẩu",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

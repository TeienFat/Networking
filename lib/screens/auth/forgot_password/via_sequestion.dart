import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/account_model.dart';
import 'package:networking/screens/auth/forgot_password/reset_password.dart';
import 'package:tiengviet/tiengviet.dart';

class ViaSeQuestion extends StatefulWidget {
  ViaSeQuestion({super.key, required this.account});
  final Account account;

  @override
  State<ViaSeQuestion> createState() => _ViaSeQuestionState();
}

var _enteredAnswer = '';
final _formKey = GlobalKey<FormState>();

class _ViaSeQuestionState extends State<ViaSeQuestion> {
  void _checkSeAnswer(BuildContext context) {
    final _enteredAnswerParse = TiengViet.parse(_enteredAnswer);
    final _accountAnswerParse = TiengViet.parse(widget.account.answer!);
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if ((_enteredAnswerParse.length == _accountAnswerParse.length) &&
        (_enteredAnswerParse.toLowerCase() ==
            _accountAnswerParse.toLowerCase())) {
      showSnackbar(context, 'Câu trả lời chính xác', Duration(seconds: 3), true,
          subtitle: 'Hãy đặt lại mật khẩu');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ResetPassword(loginName: widget.account.loginName!),
        ),
      );
    } else {
      showSnackbar(
          context, 'Câu trả lời chưa đúng', Duration(seconds: 2), false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: 10.sp, bottom: 10.sp, left: 10.sp, right: 10.sp),
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/forgot.png",
                    ),
                  ),
                  Text(
                    "Hãy điền vào câu trả lời của bạn",
                    style: TextStyle(color: Colors.black54, fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Text(
                    widget.account.question!,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      style: TextStyle(fontSize: 16.sp),
                      decoration: InputDecoration(
                        hintText: "Câu trả lời",
                      ),
                      enableSuggestions: false,
                      validator: (value) {
                        if (value == null || value.trim().length < 3) {
                          return "Vui lòng nhập vào ít nhất 3 kí tự.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredAnswer = value!.trim();
                      },
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
                        _checkSeAnswer(context);
                      },
                      child: Text(
                        "Xác nhận trả lời",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

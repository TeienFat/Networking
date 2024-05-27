import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/account_model.dart';
import 'package:networking/models/secuquestions_model.dart';
import 'package:tiengviet/tiengviet.dart';

class ChangeSeQuestion extends StatefulWidget {
  ChangeSeQuestion({super.key, required this.account});
  final Account account;

  @override
  State<ChangeSeQuestion> createState() => _ChangeSeQuestionState();
}

class _ChangeSeQuestionState extends State<ChangeSeQuestion> {
  var _enteredAnswer;
  var _enteredOldAnswer;
  String _enteredQuestion = secuQuestions[0].content!;

  final _formKey = GlobalKey<FormState>();
  final Color _color = Color.fromARGB(255, 133, 129, 99);
  void _checkSeAnswer(BuildContext context) {
    final _enteredOldAnswerParse = TiengViet.parse(_enteredOldAnswer);
    final _accountAnswerParse = TiengViet.parse(widget.account.answer!);
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if ((_enteredOldAnswerParse.length == _accountAnswerParse.length) &&
        (_enteredOldAnswerParse.toLowerCase() ==
            _accountAnswerParse.toLowerCase())) {
      APIsAuth.resetSeQuestion(
          widget.account.loginName!, _enteredQuestion, _enteredAnswer);
      showSnackbar(context, 'Đổi câu hỏi bảo mật thành công',
          Duration(seconds: 2), true);
      Navigator.of(context).pop();
    } else {
      showSnackbar(context, 'Câu trả lời hiện tại chưa đúng',
          Duration(seconds: 2), false);
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
                  Text(
                    'Đổi câu hỏi bảo mật',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Câu hỏi bảo mật và câu trả lời hiện tại",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 15.sp),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Text(
                          widget.account.question!,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        TextFormField(
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
                            _enteredOldAnswer = value!.trim();
                          },
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Text(
                          "Câu hỏi bảo mật và câu trả lời mới",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 15.sp),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        DropdownButtonFormField<String>(
                          isExpanded: false,
                          menuMaxHeight: 200.sp,
                          dropdownColor: Colors.grey[100],
                          hint: Text(
                            'Chọn câu hỏi bảo mật',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          items: secuQuestions
                              .map((question) => DropdownMenuItem(
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      width: 270.sp,
                                      child: Text(
                                        question.content!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                    value: question.content,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _enteredQuestion = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vui lòng chọn câu hỏi bảo mật.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        TextFormField(
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
                        _checkSeAnswer(context);
                      },
                      child: Text(
                        "Đổi câu hỏi bảo mật",
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

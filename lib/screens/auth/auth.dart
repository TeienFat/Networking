import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/bloc/notification_list/notification_list_bloc.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/main.dart';
import 'package:networking/models/secuquestions_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/auth/forgot_password/forgot_password.dart';
import 'package:uuid/uuid.dart';
import 'package:networking/helpers/helpers.dart';

final _uuid = Uuid();

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _loginFailed = false;
  var _enteredLoginName;
  var _enteredPassword;
  var _enteredUserName;
  var _enteredAnswer;
  var _isAuthenticating = false;
  var _heightLogin = 220.sp;
  var _heightRegister = 155.sp;
  String _enteredQuestion = secuQuestions[0].content!;

  void _submit() async {
    final _userId = _uuid.v4();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        if (_isLogin) {
          _heightLogin = 172.sp;
          _loginFailed = false;
        } else {
          _heightRegister = 15.sp;
        }
      });
      return;
    }
    if (_isLogin) {
      _heightLogin = 220.sp;
    } else {
      _heightRegister = 155.sp;
    }

    if (_isLogin) {
      final validLogin =
          await APIsAuth.login(_enteredLoginName, _enteredPassword);
      if (validLogin) {
        context.read<UsReListBloc>().add(LoadUsReList());
        context.read<UserListBloc>().add(LoadUserList());
        context.read<ReCareListBloc>().add(LoadReCareList());
        context.read<NotificationListBloc>().add(LoadNotificationList());
        currentUserId = await APIsAuth.getCurrentUserId();
        Users? user = await APIsUser.getUserFromId(currentUserId);
        if (user!.notification!) {
          APIsUsRe.setNotificationForAllUsRe(true);
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/Main", (route) => false);
      } else {
        showSnackbar(
          context,
          "Đăng nhập thất bại",
          Duration(seconds: 2),
          false,
          subtitle: "Sai tên đăng nhập hoặc mật khẩu",
        );
        setState(() {
          _loginFailed = true;
          _heightLogin = 179.sp;
        });
      }
    } else {
      final already = await APIsAuth.checkContainsAccount(_enteredLoginName);
      if (!already) {
        APIsAuth.createNewAccount(_enteredLoginName, _enteredPassword,
            _enteredQuestion, _enteredAnswer, _userId);
        context.read<UserListBloc>().add(AddUser(
            userId: _userId,
            userName: _enteredUserName,
            email: '',
            imageUrl: '',
            gender: false,
            birthday: DateTime(2000, 01, 01),
            hobby: '',
            phone: '',
            facebook: {'': ''},
            zalo: {'': ''},
            skype: {'': ''},
            address: [],
            otherInfo: {}));

        showSnackbar(context, "Đăng kí tài khoản thành công",
            Duration(seconds: 2), true);
        context.read<UsReListBloc>().add(LoadUsReList());
        context.read<UserListBloc>().add(LoadUserList());
        context.read<ReCareListBloc>().add(LoadReCareList());
        currentUserId = await APIsAuth.getCurrentUserId();
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/Main", (route) => false);
      } else {
        showSnackbar(context, "Tên đăng nhập đã được sử dụng",
            Duration(seconds: 2), false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (_isLogin)
                  Padding(
                    padding: EdgeInsets.only(top: 18.sp),
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 220.sp,
                      width: 220.sp,
                    ),
                  ),
                SizedBox(
                  height: 30.sp,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(fontSize: 16.sp),
                        decoration: InputDecoration(
                            hintText: "Tên đăng nhập", counterText: ''),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        maxLength: 20,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Tên đăng nhập không được để trống.";
                          }
                          if (value.length < 3 || value.length > 20) {
                            return "Tên đăng nhập phải có ít nhất 3 kí tự.";
                          }
                          if (value.trim().contains(' ')) {
                            return "Tên đăng nhập không được có khoảng trắng";
                          }
                          if (RegExp(r'[!@#$%^&*(),.?":{}|<>+_=/\\[\]-]|\p{L}')
                              .hasMatch(value.trim())) {
                            return 'Tên đăng nhập không chứa kí tự đặc biệt';
                          }
                          if (RegExp(
                                  r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ|À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ|è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ|È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ|ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ|Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ|ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ|Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ|ì|í|ị|ỉ|ĩ|Ì|Í|Ị|Ỉ|Ĩ|đ|Đ|ỳ|ý|ỵ|ỷ|ỹ|Ỳ|Ý|Ỵ|Ỷ|Ỹ')
                              .hasMatch(value.trim())) {
                            return 'Tên đăng nhập không chứa Tiếng Việt';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _enteredLoginName = value!.trim();
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      SizedBox(
                        height: 18.sp,
                      ),
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
                      ),
                      if (_isLogin && _loginFailed)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _formKey.currentState!.save();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(
                                      loginName: _enteredLoginName),
                                ),
                              );
                            },
                            child: Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.black),
                            ),
                          ),
                        ),
                      if (!_isLogin)
                        SizedBox(
                          height: 18.sp,
                        ),
                      if (!_isLogin)
                        TextFormField(
                          style: TextStyle(fontSize: 16.sp),
                          decoration: InputDecoration(
                            hintText: "Nhập lại mật khẩu",
                          ),
                          obscureText: true,
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                          validator: (value) {
                            if (value != _enteredPassword) {
                              return "Nhập lại mật khẩu không đúng.";
                            }
                            return null;
                          },
                        ),
                      if (!_isLogin)
                        SizedBox(
                          height: 18.sp,
                        ),
                      if (!_isLogin)
                        TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: "Họ và tên",
                          ),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.trim().length < 3) {
                              return "Vui lòng nhập vào ít nhất 3 kí tự.";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredUserName = value!.trim();
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                      if (!_isLogin)
                        SizedBox(
                          height: 18.sp,
                        ),
                      if (!_isLogin)
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
                      if (!_isLogin)
                        SizedBox(
                          height: 18.sp,
                        ),
                      if (!_isLogin)
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
                SizedBox(height: _isLogin ? _heightLogin : _heightRegister),
                if (_isAuthenticating)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: const CircularProgressIndicator(),
                  ),
                if (!_isAuthenticating)
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStatePropertyAll(
                        _isLogin
                            ? EdgeInsetsDirectional.symmetric(
                                horizontal: 126.sp, vertical: 15.sp)
                            : EdgeInsetsDirectional.symmetric(
                                horizontal: 116.sp, vertical: 15.sp),
                      ),
                    ),
                    child: Text(
                      _isLogin ? "Đăng nhập" : "Tạo tài khoản",
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                    onPressed: () async {
                      _formKey.currentState!.save();
                      _submit();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                if (!_isAuthenticating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin ? "Chưa có tài khoản?" : "Đã có tài khoản?",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin ? "Tạo tài khoản" : "Đăng nhập",
                          style: TextStyle(
                              fontSize: 16.sp, color: Colors.orange[600]),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

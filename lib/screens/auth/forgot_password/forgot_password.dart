import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/account_model.dart';
import 'package:networking/screens/auth/forgot_password/via_email.dart';
import 'package:networking/screens/auth/forgot_password/via_sequestion.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key, required this.loginName});
  final String loginName;
  @override
  Widget build(BuildContext context) {
    final Color _color = Color.fromARGB(255, 133, 129, 99);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(top: 0, bottom: 10.sp, left: 10.sp, right: 10.sp),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/forgot.png",
                ),
              ),
              Text(
                'Hãy chọn cách mà bạn muốn khôi phục mật khẩu',
                style: TextStyle(color: Colors.black54, fontSize: 15.sp),
              ),
              SizedBox(
                height: 20.sp,
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.sp, vertical: 20.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    border: Border.all(color: _color, width: 1.sp)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: _color.withAlpha(50)),
                      child: Icon(
                        Icons.question_mark_rounded,
                        size: 30.sp,
                        color: _color,
                      ),
                    ),
                    Container(
                      width: 210.sp,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khôi phục bằng câu hỏi bảo mật',
                            style: TextStyle(
                                color: _color,
                                fontWeight: FontWeight.w900,
                                fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                            'Bạn sẽ được đổi mật khẩu mới sau khi trả lời đúng câu hỏi bảo mật mà bạn đã đăng kí',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 11.5.sp),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        Account? account =
                            await APIsAuth.getAccountFromLoginName(loginName);
                        if (account != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViaSeQuestion(account: account),
                            ),
                          );
                        } else {
                          showSnackbar(
                              context,
                              'Vui lòng kiểm tra lại tên đăng nhập',
                              Duration(seconds: 2),
                              false);
                        }
                      },
                      icon: Icon(
                        Icons.arrow_circle_right_sharp,
                        size: 40.sp,
                        color: _color,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.sp,
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.sp, vertical: 20.sp),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    border: Border.all(color: _color, width: 1.sp)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: _color.withAlpha(50)),
                      child: Icon(
                        Icons.email_outlined,
                        size: 30.sp,
                        color: _color,
                      ),
                    ),
                    Container(
                      width: 210.sp,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khôi phục bằng Email',
                            style: TextStyle(
                                color: _color,
                                fontWeight: FontWeight.w900,
                                fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                            'Bạn sẽ được đổi mật khẩu mới sau khi xác thực email thành công',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 11.5.sp),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViaEmail(),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_circle_right_sharp,
                        size: 40.sp,
                        color: _color,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

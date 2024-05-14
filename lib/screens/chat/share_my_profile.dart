import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/relationships/share/share_relationship.dart';

class ShareMyProFile extends StatefulWidget {
  const ShareMyProFile({super.key});

  @override
  State<ShareMyProFile> createState() => _ShareMyProFileState();
}

class _ShareMyProFileState extends State<ShareMyProFile> {
  void _onShare() async {
    final meId = await APIsAuth.getCurrentUserId();
    Users? user = await APIsUser.getUserFromId(meId!);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShareRelationship.shareToCloud(
          user: user!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 10.sp, right: 10.sp, top: 150.sp, bottom: 10.sp),
      child: Column(
        children: [
          Image.asset('assets/images/share_icon.png'),
          SizedBox(height: 50.sp),
          Text(
            "Hãy chia sẻ thông tin của mình để có thể    kết nối với mọi người!",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.sp),
          ElevatedButton(
              onPressed: _onShare,
              child: Text(
                "Chia sẻ ngay",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}

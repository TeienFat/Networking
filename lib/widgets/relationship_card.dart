import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/models/user_model.dart';

class RelationShipCard extends StatelessWidget {
  const RelationShipCard({super.key, required this.users});
  final Users users;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.purple[50]),
      padding: EdgeInsets.all(10.sp),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[100],
            backgroundImage: AssetImage(users.imageUrl != ''
                ? users.imageUrl!
                : 'assets/images/user.png'),
            radius: 30.sp,
          ),
          SizedBox(
            width: 10.sp,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                users.userName!,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(
                    width: 3.sp,
                  ),
                  Text("Em gái mưa")
                ],
              ),
              Text("Đã chăm sóc: 99"),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow[700],
                size: 35.sp,
              ),
              SizedBox(
                height: 10.sp,
              ),
              Text("2 tháng trước"),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/detail/custom_appbar.dart';
import 'package:networking/screens/relationships/detail/custom_button_switch.dart';

class DetailRelationship extends StatefulWidget {
  const DetailRelationship(
      {super.key, required this.user, required this.userRelationship});
  final Users user;
  final UserRelationship userRelationship;

  @override
  State<DetailRelationship> createState() => _DetailRelationshipState();
}

class _DetailRelationshipState extends State<DetailRelationship> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: MySliverAppBar(
                expandedHeight: 200.0,
                user: widget.user,
                userRelationship: widget.userRelationship),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: MySliverButtonSwicth(
                expandedHeight: 200.0,
                user: widget.user,
                userRelationship: widget.userRelationship),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 120,
              ),
              listCardWidget(text1: 'Full Name:', text2: 'George John Carter'),
              listCardWidget(text1: 'Father\'s Name:', text2: 'John Carter'),
              listCardWidget(text1: 'Gender:', text2: 'Male'),
              listCardWidget(text1: 'Marital Status:', text2: 'Single'),
              listCardWidget(text1: 'Email:', text2: 'jane123@123.com'),
              listCardWidget(text1: 'Username:', text2: 'misty123'),
              listCardWidget(text1: 'Phone:', text2: '0987654321'),
              listCardWidget(text1: 'Country', text2: 'India'),
              listCardWidget(text1: 'City', text2: 'Hyderabad'),
              listCardWidget(text1: 'Pincode:', text2: '500014'),
              listCardWidget(text1: 'Company:', text2: 'All Shakes'),
              listCardWidget(text1: 'Website:', text2: 'allshakes.com'),
              listCardWidget(text1: 'Position', text2: 'Manager'),
              listCardWidget(text1: 'LinkedIn Id:', text2: 'misty123'),
              listCardWidget(text1: 'Interest:', text2: 'Swimming,Cycling'),
            ]),
          )
        ],
      ),
    ));
  }

  Widget listCardWidget({required String text1, required text2}) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                fit: FlexFit.tight,
                child: Text(
                  text1,
                  style: const TextStyle(fontSize: 18),
                )),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Text(
                text2,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

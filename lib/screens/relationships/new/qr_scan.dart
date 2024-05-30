import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/relationships/edit/list_reltionship_edit.dart';
import 'package:networking/screens/relationships/new/new_relationship.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class QRScan extends StatelessWidget {
  const QRScan({super.key});

  @override
  Widget build(BuildContext context) {
    List<Relationship> relationships = [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Quét mã QR"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
            returnImage: true,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;

            if (image != null) {
              List<String> datas =
                  List<String>.from(jsonDecode(barcodes.first.rawValue!));
              Users newUser = Users.fromMap(jsonDecode(datas[0]));
              if (datas[1] != '') {
                relationships = Relationship.decode(datas[1]);
              }
              int num = relationships.length >= 2 ? 2 : 1;
              showDialog(
                useSafeArea: true,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Mối quan hệ mới từ mã QR",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.sp)),
                          child: Image(
                            image: MemoryImage(image),
                            height: 200.sp,
                          ),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        Text(
                          newUser.userName!,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        if (relationships != [])
                          SizedBox(
                            height: 20.sp,
                          ),
                        if (relationships != [])
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: getRowRelationship(
                                  relationships, num, 12.sp, 12.sp)),
                        if (relationships != [])
                          SizedBox(
                            height: 20.sp,
                          ),
                        newUser.address!.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.mapLocationDot,
                                    size: 12.sp,
                                  ),
                                  SizedBox(
                                    width: 15.sp,
                                  ),
                                  Container(
                                    width: ScreenUtil().screenWidth * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        newUser.address![0]
                                                        .province!['name'] !=
                                                    null &&
                                                newUser.address![0]
                                                        .district!['name'] !=
                                                    null &&
                                                newUser.address![0]
                                                        .wards!['name'] !=
                                                    null
                                            ? Text(
                                                newUser.address![0].street != ''
                                                    ? "${newUser.address![0].street}, ${newUser.address![0].wards!['name']}, ${newUser.address![0].district!['name']}, ${newUser.address![0].province!['name']}"
                                                    : "${newUser.address![0].wards!['name']}, ${newUser.address![0].district!['name']}, ${newUser.address![0].province!['name']}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12.sp),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: newUser.address![0]
                                                          .province!['name'] !=
                                                      null &&
                                                  newUser.address![0]
                                                          .district!['name'] !=
                                                      null &&
                                                  newUser.address![0]
                                                          .wards!['name'] !=
                                                      null
                                              ? 3.sp
                                              : 0,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              newUser.address![0].type == 3 &&
                                                      newUser.address![0]
                                                              .name !=
                                                          null
                                                  ? newUser.address![0].name!
                                                  : showAddressTypeText(newUser
                                                      .address![0].type!),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10.sp),
                                            ),
                                            SizedBox(
                                              width: 5.sp,
                                            ),
                                            showAddressTypeIcon(
                                                newUser.address![0].type!,
                                                10.sp),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Row(
                          mainAxisAlignment: newUser.birthday != null
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: newUser.birthday != null ? 10.sp : 0,
                            ),
                            newUser.birthday != null
                                ? FaIcon(
                                    FontAwesomeIcons.birthdayCake,
                                    size: 12.sp,
                                  )
                                : SizedBox(),
                            SizedBox(
                              width: newUser.birthday != null ? 20.sp : 0,
                            ),
                            newUser.birthday != null
                                ? Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(newUser.birthday!),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp),
                                  )
                                : SizedBox(),
                            SizedBox(
                              width: newUser.birthday != null ? 20.sp : 0,
                            ),
                            newUser.gender != null
                                ? !newUser.gender!
                                    ? Icon(
                                        Icons.man_2_rounded,
                                        size: 20.sp,
                                        color: Colors.blue,
                                      )
                                    : Icon(
                                        Icons.woman_rounded,
                                        size: 20.sp,
                                        color: Colors.pink,
                                      )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        newUser.phone != ''
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.phone,
                                    size: 12.sp,
                                  ),
                                  SizedBox(
                                    width: 17.sp,
                                  ),
                                  Text(
                                    newUser.phone!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.grey)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Hủy"),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListEditRelationship(
                                  newUser: newUser,
                                  newRelationships: relationships,
                                ),
                              ));
                        },
                        child: Text("Cập nhật"),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green)),
                        onPressed: () async {
                          final userId = _uuid.v4();
                          Users user = Users(
                              userId: userId,
                              userName: newUser.userName!,
                              email: newUser.email!,
                              imageUrl: newUser.imageUrl!,
                              gender: newUser.gender!,
                              birthday: newUser.birthday != null
                                  ? newUser.birthday
                                  : DateTime(2000, 01, 01),
                              hobby: newUser.hobby!,
                              phone: newUser.phone!,
                              facebook: newUser.facebook!.isNotEmpty
                                  ? newUser.facebook!
                                  : {'': ''},
                              zalo: newUser.zalo!.isNotEmpty
                                  ? newUser.zalo!
                                  : {'': ''},
                              skype: newUser.skype!.isNotEmpty
                                  ? newUser.skype!
                                  : {'': ''},
                              address: newUser.address!,
                              otherInfo: newUser.otherInfo!,
                              notification: true,
                              createdAt: null,
                              updateAt: null,
                              deleteAt: null,
                              numDayOfAutoDelete: 30,
                              isShare: false,
                              isOnline: false,
                              blockUsers: [],
                              token: '');

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewRelationship.fromImport(
                                        user: user,
                                        relationships: relationships,
                                      )));
                        },
                        child: Text("Thêm"),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

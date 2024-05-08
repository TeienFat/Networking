import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/address_model.dart';
import 'package:networking/models/relationship_model.dart';

import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/share/qr_view.dart';

class ShareRelationship extends StatefulWidget {
  const ShareRelationship(
      {super.key, required this.user, required this.userRelationship});
  const ShareRelationship.myProfile({super.key, required this.user})
      : this.userRelationship = null;
  final Users user;
  final UserRelationship? userRelationship;
  @override
  State<ShareRelationship> createState() => _ShareRelationshipState();
}

class _ShareRelationshipState extends State<ShareRelationship> {
  bool _isCheckedRelationships = false;
  bool _isCheckedBirthday = false;
  bool _isCheckedGender = false;
  bool _isCheckedHobby = false;
  bool _isCheckedAddress = false;
  bool _isCheckedPhone = false;
  bool _isCheckedEmail = false;
  bool _isCheckedFB = false;
  bool _isCheckedZalo = false;
  bool _isCheckedSkype = false;
  bool _isCheckedOtherInfo = false;
  late List<String> dataShare;
  bool _isSelectAll = false;

  late List<Relationship> _listRelationship;
  late List<Address> _listAddress;
  late Map<String, dynamic> _otherInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.userRelationship != null) {
      _listRelationship = widget.userRelationship!.relationships!;
    }
    _listAddress = widget.user.address!;
    _otherInfo = widget.user.otherInfo!;
  }

  List<Widget> _getAllOtherInfo() {
    List<Widget> list = [];

    _otherInfo.forEach((key, value) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenUtil().screenWidth,
            child: Padding(
              padding: _isCheckedOtherInfo
                  ? EdgeInsets.all(0)
                  : EdgeInsets.only(left: 10.sp, top: 1.sp, bottom: 1.sp),
              child: Row(
                children: [
                  _isCheckedOtherInfo
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              if (_otherInfo.length > 1) {
                                _otherInfo.remove(key);
                              }
                            });
                          },
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        )
                      : SizedBox(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                            fontSize: 14.sp, overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          key == widget.user.otherInfo!.keys.last ? SizedBox() : hr,
        ],
      ));
    });

    return list;
  }

  void _selectAll(bool select) {
    setState(() {
      if (widget.userRelationship != null) {
        _isCheckedRelationships = select;
      }
      _isCheckedBirthday = select;
      _isCheckedGender = select;
      _isCheckedHobby = select;
      _isCheckedAddress = select;
      _isCheckedPhone = select;
      _isCheckedEmail = select;
      _isCheckedFB = select;
      _isCheckedZalo = select;
      _isCheckedSkype = select;
      _isCheckedOtherInfo = select;
      _isSelectAll = select;
    });
  }

  void _shareRelationship() {
    Users userShare = Users(
        userId: '',
        userName: widget.user.userName,
        email: _isCheckedEmail ? widget.user.email : '',
        imageUrl: '',
        gender: _isCheckedGender ? widget.user.gender : false,
        birthday: _isCheckedBirthday ? widget.user.birthday : null,
        hobby: _isCheckedHobby ? widget.user.hobby : '',
        phone: _isCheckedPhone ? widget.user.phone : '',
        facebook: _isCheckedFB ? widget.user.facebook : {},
        zalo: _isCheckedZalo ? widget.user.zalo : {},
        skype: _isCheckedSkype ? widget.user.skype : {},
        address: _isCheckedAddress ? _listAddress : [],
        otherInfo: _isCheckedSkype ? _otherInfo : {},
        notification: true,
        createdAt: null,
        updateAt: null,
        deleteAt: null,
        isOnline: false,
        blockUsers: [],
        token: '');
    if (widget.userRelationship != null) {
      dataShare = [
        jsonEncode(userShare.toMap()),
        Relationship.encode(_listRelationship)
      ];
    } else {
      dataShare = [jsonEncode(userShare.toMap()), ''];
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRView(data: jsonEncode(dataShare)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chia sẻ mối quan hệ"),
        actions: [
          TextButton(
            onPressed: _shareRelationship,
            child: Padding(
              padding: EdgeInsets.only(right: 10.sp),
              child: Text(
                "Chia sẻ",
                style: TextStyle(color: Colors.blue[800]),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5.sp),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      _selectAll(_isSelectAll ? false : true);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.sp),
                      child: Text(
                        _isSelectAll ? "Bỏ chọn tất cả" : "Chọn tất cả",
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.blue[800]),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 70.sp,
                        backgroundColor: Colors.grey,
                        child: Image.asset(
                          "assets/images/user.png",
                          width: 100.sp,
                        ),
                        foregroundImage: widget.user.imageUrl != ''
                            ? FileImage(File(widget.user.imageUrl!))
                            : null,
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.only(right: 5.sp, left: 12.sp),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.sp),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ]),
                        child: Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: Text(
                            widget.user.userName!,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      if (widget.userRelationship != null)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.sp),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ]),
                          child: Padding(
                            padding: EdgeInsets.all(5.sp),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 10.sp),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Mối quan hệ với tôi",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp),
                                      ),
                                      Spacer(),
                                      Checkbox(
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          if (!states.contains(
                                              MaterialState.selected)) {
                                            return Colors.white;
                                          }
                                          return null;
                                        }),
                                        activeColor: Colors.blue[800],
                                        value: _isCheckedRelationships,
                                        onChanged: (value) {
                                          setState(() {
                                            _isCheckedRelationships = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                                Column(
                                  children: _listRelationship.map((e) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(
                                              _isCheckedRelationships
                                                  ? 0
                                                  : 10.5.sp),
                                          child: Row(
                                            children: [
                                              _isCheckedRelationships
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (_listRelationship
                                                                  .length >
                                                              1) {
                                                            _listRelationship
                                                                .remove(e);
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              Text(
                                                e.name!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                              Spacer(),
                                              showRelationshipTypeIcon(
                                                  e.type!, 20.sp),
                                              SizedBox(
                                                width: _isCheckedRelationships
                                                    ? 13.sp
                                                    : 2.5.sp,
                                              )
                                            ],
                                          ),
                                        ),
                                        e != _listRelationship.last
                                            ? hr
                                            : SizedBox(),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.userRelationship != null)
                        SizedBox(
                          height: 10.sp,
                        ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.sp),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ]),
                        child: Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                  ),
                                ),
                                padding: EdgeInsets.only(left: 10.sp),
                                child: Row(
                                  children: [
                                    Text(
                                      "Địa chỉ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp),
                                    ),
                                    Spacer(),
                                    Checkbox(
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (!states
                                            .contains(MaterialState.selected)) {
                                          return Colors.white;
                                        }
                                        return null;
                                      }),
                                      activeColor: Colors.blue[800],
                                      value: _isCheckedAddress,
                                      onChanged: (value) {
                                        setState(() {
                                          _isCheckedAddress = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.sp),
                                child: Column(
                                  children: widget.user.address!.map((e) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: _isCheckedAddress
                                                  ? 0
                                                  : 10.sp),
                                          child: Row(
                                            children: [
                                              _isCheckedAddress
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (_listAddress
                                                                  .length >
                                                              1) {
                                                            _listAddress
                                                                .remove(e);
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              Container(
                                                width: _isCheckedAddress
                                                    ? ScreenUtil().screenWidth *
                                                        0.7
                                                    : ScreenUtil().screenWidth *
                                                        0.8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    e.province!['name'] !=
                                                                null &&
                                                            e.district![
                                                                    'name'] !=
                                                                null &&
                                                            e.wards!['name'] !=
                                                                null
                                                        ? Text(
                                                            e.street != ''
                                                                ? "${e.street}, ${e.wards!['name']}, ${e.district!['name']}, ${e.province!['name']}"
                                                                : "${e.wards!['name']}, ${e.district!['name']}, ${e.province!['name']}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 3,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 16),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                      height: e.province!['name'] != null &&
                                                              e.district![
                                                                      'name'] !=
                                                                  null &&
                                                              e.wards![
                                                                      'name'] !=
                                                                  null
                                                          ? 5
                                                          : 0,
                                                    ),
                                                    Text(
                                                      e.type == 3 &&
                                                              e.name != null
                                                          ? e.name!
                                                          : showAddressTypeText(
                                                              e.type!),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              showAddressTypeIcon(
                                                  e.type!, 20.sp),
                                              SizedBox(
                                                width: _isCheckedAddress
                                                    ? 13.sp
                                                    : 13.sp,
                                              )
                                            ],
                                          ),
                                        ),
                                        e != _listAddress.last
                                            ? hr
                                            : SizedBox(),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.sp),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ]),
                        child: Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  FaIcon(FontAwesomeIcons.birthdayCake),
                                  SizedBox(
                                    width: 20.sp,
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(widget.user.birthday!),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                  Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (!states
                                          .contains(MaterialState.selected)) {
                                        return Colors.white;
                                      }
                                      return null;
                                    }),
                                    activeColor: Colors.blue[800],
                                    value: _isCheckedBirthday,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedBirthday = value!;
                                      });
                                    },
                                  ),
                                  Spacer(),
                                  !widget.user.gender!
                                      ? Icon(
                                          Icons.man_2_rounded,
                                          size: 40.sp,
                                          color: Colors.blue,
                                        )
                                      : Icon(
                                          Icons.woman_rounded,
                                          size: 40.sp,
                                          color: Colors.pink,
                                        ),
                                  Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (!states
                                          .contains(MaterialState.selected)) {
                                        return Colors.white;
                                      }
                                      return null;
                                    }),
                                    activeColor: Colors.blue[800],
                                    value: _isCheckedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedGender = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              hr,
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  FaIcon(FontAwesomeIcons.solidHeart),
                                  SizedBox(
                                    width: 17.sp,
                                  ),
                                  Text(
                                    widget.user.hobby!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                  Spacer(),
                                  Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (!states
                                          .contains(MaterialState.selected)) {
                                        return Colors.white;
                                      }
                                      return null;
                                    }),
                                    activeColor: Colors.blue[800],
                                    value: _isCheckedHobby,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedHobby = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              hr,
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  FaIcon(FontAwesomeIcons.phone),
                                  SizedBox(
                                    width: 17.sp,
                                  ),
                                  Text(
                                    widget.user.phone!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                  Spacer(),
                                  Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (!states
                                          .contains(MaterialState.selected)) {
                                        return Colors.white;
                                      }
                                      return null;
                                    }),
                                    activeColor: Colors.blue[800],
                                    value: _isCheckedPhone,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedPhone = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              hr,
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  Icon(
                                    Icons.mail,
                                  ),
                                  SizedBox(
                                    width: 17.sp,
                                  ),
                                  Text(
                                    widget.user.email!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                  Spacer(),
                                  Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (!states
                                          .contains(MaterialState.selected)) {
                                        return Colors.white;
                                      }
                                      return null;
                                    }),
                                    activeColor: Colors.blue[800],
                                    value: _isCheckedEmail,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedEmail = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              hr,
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  FaIcon(FontAwesomeIcons.facebook),
                                  SizedBox(
                                    width: 17.sp,
                                  ),
                                  Text(
                                    widget.user.facebook!.keys.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                  Spacer(),
                                  Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (!states
                                          .contains(MaterialState.selected)) {
                                        return Colors.white;
                                      }
                                      return null;
                                    }),
                                    activeColor: Colors.blue[800],
                                    value: _isCheckedFB,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedFB = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              hr,
                              Row(children: [
                                SizedBox(
                                  width: 10.sp,
                                ),
                                FaIcon(FontAwesomeIcons.skype),
                                SizedBox(
                                  width: 20.sp,
                                ),
                                Text(
                                  widget.user.skype!.keys.first,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp),
                                ),
                                Spacer(),
                                Checkbox(
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) {
                                    if (!states
                                        .contains(MaterialState.selected)) {
                                      return Colors.white;
                                    }
                                    return null;
                                  }),
                                  activeColor: Colors.blue[800],
                                  value: _isCheckedSkype,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCheckedSkype = value!;
                                    });
                                  },
                                ),
                              ]),
                              hr,
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5.sp,
                                  ),
                                  Image.asset(
                                    'assets/images/icon-zalo.png',
                                    width: 25.sp,
                                  ),
                                  SizedBox(
                                    width: 18.sp,
                                  ),
                                  Text(
                                    widget.user.zalo!.keys.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                  Spacer(),
                                  Checkbox(
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (!states
                                          .contains(MaterialState.selected)) {
                                        return Colors.white;
                                      }
                                      return null;
                                    }),
                                    activeColor: Colors.blue[800],
                                    value: _isCheckedZalo,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedZalo = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.sp),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 5),
                          ),
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[350],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            padding: EdgeInsets.only(left: 10.sp),
                            child: Row(
                              children: [
                                Text(
                                  "Thông tin khác",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp),
                                ),
                                Spacer(),
                                Checkbox(
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) {
                                    if (!states
                                        .contains(MaterialState.selected)) {
                                      return Colors.white;
                                    }
                                    return null;
                                  }),
                                  activeColor: Colors.blue[800],
                                  value: _isCheckedOtherInfo,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCheckedOtherInfo = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Column(
                            children: _getAllOtherInfo(),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 100.sp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:networking/apis/apis_relationships.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/address_model.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/new/change_address.dart';
import 'package:networking/screens/relationships/new/change_relationship.dart';
import 'package:networking/widgets/date_picker.dart';
import 'package:networking/widgets/user_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

final _uuid = Uuid();

class EditRelationship extends StatefulWidget {
  const EditRelationship(
      {super.key, required this.user, required this.userRelationship})
      : newUser = null,
        newRelationships = null,
        type = 0;
  const EditRelationship.update(
      {super.key,
      required this.user,
      required this.userRelationship,
      required this.newUser,
      required this.newRelationships})
      : type = 1;
  const EditRelationship.updateFromPhonebook(
      {super.key,
      required this.user,
      required this.userRelationship,
      required this.newUser,
      required this.newRelationships})
      : type = 2;
  final Users user;
  final UserRelationship userRelationship;
  final Users? newUser;
  final List<Relationship>? newRelationships;
  final int type;
  @override
  State<EditRelationship> createState() => _EditRelationshipState();
}

class _EditRelationshipState extends State<EditRelationship> {
  final _formKey = GlobalKey<FormState>();

  File? _enteredImageFile;

  var _enteredUserName;
  var _enteredPhone;
  var _enteredEmail;
  var _enteredHobby;
  var _enteredGender;
  var _enteredSpecial;

  TextEditingController _enteredTitle = TextEditingController();
  TextEditingController _enteredContent = TextEditingController();
  TextEditingController _enteredFBName = TextEditingController();
  TextEditingController _enteredFBLink = TextEditingController();
  TextEditingController _enteredSkypeName = TextEditingController();
  TextEditingController _enteredSkypeId = TextEditingController();
  TextEditingController _enteredZaloName = TextEditingController();
  TextEditingController _enteredZaloPhone = TextEditingController();

  late DateTime _enteredBirthday;
  var _isNewOtherInfo = false;
  var _numOfRelationship;
  var _numOfAddress;
  late List<Relationship> _listRelationship;
  late List<Address> _listAddress;
  late Map<String, dynamic> _otherInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type != 0) {
      _enteredSpecial = widget.userRelationship.special;
      if (widget.newUser != null) {
        if (widget.newUser!.imageUrl != '') {
          _enteredImageFile = File(widget.newUser!.imageUrl!);
        } else {
          if (widget.user.imageUrl! != '') {
            _enteredImageFile = File(widget.user.imageUrl!);
          }
        }
        _enteredUserName = widget.newUser!.userName;
        widget.newUser!.phone != ''
            ? _enteredPhone = widget.newUser!.phone
            : _enteredPhone = widget.user.phone;
        widget.newUser!.email != ''
            ? _enteredEmail = widget.newUser!.email
            : _enteredEmail = widget.user.email;
        widget.newUser!.hobby != ''
            ? _enteredHobby = widget.newUser!.hobby
            : _enteredHobby = widget.user.hobby;

        _enteredGender = widget.newUser!.gender;

        if (widget.newUser!.facebook!.keys.first.isNotEmpty) {
          _enteredFBName.text = widget.newUser!.facebook!.keys.first;
        } else {
          if (widget.user.facebook!.keys.first.isNotEmpty)
            _enteredFBName.text = widget.user.facebook!.keys.first;
        }

        if (widget.newUser!.facebook!.values.first.isNotEmpty) {
          _enteredFBLink.text = widget.newUser!.facebook!.values.first;
        } else {
          if (widget.user.facebook!.values.first.isNotEmpty)
            _enteredFBLink.text = widget.user.facebook!.values.first;
        }

        if (widget.newUser!.skype!.keys.first.isNotEmpty) {
          _enteredSkypeName.text = widget.newUser!.skype!.keys.first;
        } else {
          if (widget.user.skype!.keys.first.isNotEmpty)
            _enteredSkypeName.text = widget.user.skype!.keys.first;
        }

        if (widget.newUser!.skype!.values.first.isNotEmpty) {
          _enteredSkypeId.text = widget.newUser!.skype!.values.first;
        } else {
          if (widget.user.skype!.values.first.isNotEmpty)
            _enteredSkypeId.text = widget.user.skype!.values.first;
        }

        if (widget.newUser!.zalo!.keys.first.isNotEmpty) {
          _enteredZaloName.text = widget.newUser!.zalo!.keys.first;
        } else {
          if (widget.user.zalo!.keys.first.isNotEmpty)
            _enteredZaloName.text = widget.user.zalo!.keys.first;
        }

        if (widget.newUser!.zalo!.values.first.isNotEmpty) {
          _enteredZaloPhone.text = widget.newUser!.zalo!.values.first;
        } else {
          if (widget.user.zalo!.values.first.isNotEmpty)
            _enteredZaloPhone.text = widget.user.zalo!.values.first;
        }

        widget.newUser!.birthday != null
            ? _enteredBirthday = widget.newUser!.birthday!
            : _enteredBirthday = widget.user.birthday!;
        if (widget.newUser!.otherInfo!.isNotEmpty) {
          _otherInfo = widget.user.otherInfo!;
          _otherInfo.addAll((widget.newUser!.otherInfo!));
        } else {
          _otherInfo = widget.user.otherInfo!;
        }
        if (widget.newUser!.address!.isNotEmpty) {
          _listAddress = widget.user.address! + widget.newUser!.address!;
          _numOfAddress = _listAddress.length;
        } else {
          _numOfAddress = widget.user.address!.length;
          _listAddress = widget.user.address!;
        }

        if (widget.newRelationships!.isNotEmpty) {
          _listRelationship =
              widget.userRelationship.relationships! + widget.newRelationships!;
          _numOfRelationship = _listRelationship.length;
        } else {
          _numOfRelationship = widget.userRelationship.relationships!.length;
          _listRelationship = widget.userRelationship.relationships!;
        }
      }
    } else {
      if (widget.user.imageUrl! != '') {
        _enteredImageFile = File(widget.user.imageUrl!);
      }

      _enteredUserName = widget.user.userName;
      _enteredPhone = widget.user.phone;
      _enteredEmail = widget.user.email;
      _enteredHobby = widget.user.hobby;
      _enteredGender = widget.user.gender!;

      if (widget.user.facebook!.keys.first.isNotEmpty)
        _enteredFBName.text = widget.user.facebook!.keys.first;
      if (widget.user.facebook!.values.first.isNotEmpty)
        _enteredFBLink.text = widget.user.facebook!.values.first;

      if (widget.user.skype!.keys.first.isNotEmpty)
        _enteredSkypeName.text = widget.user.skype!.keys.first;
      if (widget.user.skype!.values.first.isNotEmpty)
        _enteredSkypeId.text = widget.user.skype!.values.first;

      if (widget.user.zalo!.keys.first.isNotEmpty)
        _enteredZaloName.text = widget.user.zalo!.keys.first;
      if (widget.user.zalo!.values.first.isNotEmpty)
        _enteredZaloPhone.text = widget.user.zalo!.values.first;

      _enteredBirthday = widget.user.birthday!;
      _numOfRelationship = widget.userRelationship.relationships!.length;
      _numOfAddress = widget.user.address!.length;
      _listRelationship = widget.userRelationship.relationships!;
      _enteredSpecial = widget.userRelationship.special;
      _listAddress = widget.user.address!;
      _otherInfo = widget.user.otherInfo!;
    }
  }

  void _updateRelationship() async {
    final isValid = _formKey.currentState!.validate();
    final userId = widget.user.userId!;
    if (!isValid) {
      return;
    } else {
      if (_listRelationship.isNotEmpty) {
        Map<String, String> _enteredFacebook = {
          _enteredFBName.text.trim(): _enteredFBLink.text.trim()
        };
        Map<String, String> _enteredSkype = {
          _enteredSkypeName.text.trim(): _enteredSkypeId.text.trim()
        };
        Map<String, String> _enteredZalo = {
          _enteredZaloName.text.trim(): _enteredZaloPhone.text.trim()
        };
        String imageUrl;
        if (_enteredImageFile != null) {
          if (_enteredImageFile!.path != widget.user.imageUrl!) {
            if (_enteredImageFile!.path != widget.newUser!.imageUrl!) {
              var time = DateTime.now().microsecondsSinceEpoch;
              File(widget.user.imageUrl!).delete();
              File(widget.newUser!.imageUrl!).delete();
              imageUrl = await APIsUser.saveUserImage(
                  _enteredImageFile!, '${userId + '-T' + time.toString()}.jpg');
            } else {
              File(widget.user.imageUrl!).delete();
              imageUrl = widget.newUser!.imageUrl!;
            }
          } else {
            imageUrl = widget.user.imageUrl!;
          }
        } else {
          imageUrl = '';
        }

        context.read<UserListBloc>().add(UpdateUser(
            userId: userId,
            userName: _enteredUserName,
            email: _enteredEmail,
            imageUrl: imageUrl,
            gender: _enteredGender,
            birthday: _enteredBirthday,
            hobby: _enteredHobby,
            phone: _enteredPhone,
            facebook: _enteredFacebook,
            zalo: _enteredZalo,
            skype: _enteredSkype,
            address: _listAddress,
            otherInfo: _otherInfo));

        context.read<UsReListBloc>().add(UpdateUsRe(
            usReId: widget.userRelationship.usReId!,
            special: _enteredSpecial,
            relationships: _listRelationship));

        if (widget.type == 1) {
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pop()
            ..pop()
            ..pop();
        }
        if (widget.type == 2) {
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pop()
            ..pop();
        }
        if (widget.type == 0) {
          Navigator.of(context).pop();
        }
      } else {
        showSnackbar(context, "Vui lòng thiết lập mối quan hệ",
            Duration(seconds: 3), false, ScreenUtil().screenHeight - 120);
        return;
      }
    }
  }

  void _addRelationship(int num) async {
    final relationships = await APIsRelationship.getAllRelationship();
    setState(() {
      _listRelationship.add(relationships[num]);
    });
  }

  void _addAddress(int num, String name) async {
    setState(() {
      _listAddress.add(Address(
          province: {},
          district: {},
          wards: {},
          street: '',
          name: name,
          type: num));
    });
  }

  void _addOtherInfo(String title, String content) {
    if (title.isEmpty && content.isEmpty) {
      return;
    } else {
      setState(() {
        _otherInfo[title] = content;
      });
    }
  }

  void _changeRelationship(Relationship oldRe, Relationship newRe) {
    var index = _listRelationship.indexOf(oldRe);
    setState(() {
      _listRelationship.remove(oldRe);
      _listRelationship.insert(index, newRe);
    });
  }

  void _changeAddress(Address oldAddress, Address newAddress) {
    var index = _listAddress.indexOf(oldAddress);
    setState(() {
      _listAddress.remove(oldAddress);
      _listAddress.insert(index, newAddress);
    });
  }

  void _pickBirthday(DateTime datePick) {
    setState(() {
      _enteredBirthday = datePick;
    });
  }

  List<Widget> _getAllOtherInfo() {
    List<Widget> list = [];

    _otherInfo.forEach((key, value) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenUtil().screenWidth,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _otherInfo.remove(key);
                    });
                  },
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                ),
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
                          fontSize: 12.sp, overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          hr,
        ],
      ));
    });

    return list;
  }

  void _launchSocial(String url, String fallbackUrl) async {
    final Uri uri = Uri.parse(fallbackUrl);
    await launchUrl(uri);
    try {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (e) {
      final Uri fallbackUri = Uri.parse(fallbackUrl);
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }

  void _searchFacebook() {
    if (_enteredFBName.text.trim().isEmpty &&
        _enteredFBLink.text.trim().isEmpty) {
      showSnackbar(context, 'Hãy nhập tên tài khoản hoặc link',
          Duration(seconds: 3), false, ScreenUtil().screenHeight - 120);
    } else {
      if (_enteredFBLink.text.trim().isNotEmpty) {
        _launchSocial('fb://page/', _enteredFBLink.text.trim());
      }
      if (_enteredFBName.text.trim().isNotEmpty) {
        String search =
            'https://www.facebook.com/search/top/?q=${_enteredFBName.text.trim()}';
        _launchSocial('fb://page/', search);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chỉnh sửa mối quan hệ"),
        actions: [
          TextButton(
            onPressed: () {
              _formKey.currentState!.save();
              _updateRelationship();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.sp),
              child: Text(
                "Xong",
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    UserImagePicker(
                      initImageUrl: _enteredImageFile,
                      onPickImage: (pickedImage) {
                        _enteredImageFile = pickedImage;
                      },
                    ),
                    SizedBox(
                      height: 20.sp,
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
                              offset: Offset(0, 3),
                            ),
                          ]),
                      child: Padding(
                        padding: EdgeInsets.all(5.sp),
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: _enteredUserName,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Họ tên",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Họ tên không được để trống.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredUserName = value!.trim();
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5.sp),
                                child: Text(
                                  "*",
                                  style: TextStyle(
                                      fontSize: 18.sp, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          hr,
                          Row(
                            children: [
                              SizedBox(
                                width: 10.sp,
                              ),
                              Text(
                                "Chăm sóc đặc biệt",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                              Spacer(),
                              Switch(
                                value: _enteredSpecial,
                                onChanged: (value) {
                                  setState(() {
                                    _enteredSpecial = value;
                                  });
                                },
                                activeColor: Colors.yellow[900],
                                inactiveTrackColor: Colors.grey[400],
                              ),
                            ],
                          ),
                          hr,
                          Column(
                            children: _listRelationship.map((e) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _listRelationship.remove(e);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        e.name!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                      Spacer(),
                                      showRelationshipTypeIcon(e.type!, 20.sp),
                                      SizedBox(width: 10.sp),
                                      IconButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeRelationship(
                                            relationshipID: e.relationshipId!,
                                            onChangeRelationship:
                                                (relationship) {
                                              _changeRelationship(
                                                  e, relationship);
                                            },
                                          ),
                                        )),
                                        icon: Icon(
                                          Icons.arrow_right_outlined,
                                          color: Colors.grey,
                                          size: 25.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  hr,
                                ],
                              );
                            }).toList(),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                EdgeInsets.only(left: 8.sp),
                              ),
                            ),
                            onPressed: () {
                              if (_numOfRelationship >= 27) {
                                _numOfRelationship = 0;
                              }
                              setState(() {
                                if (_numOfRelationship < 27) {
                                  _addRelationship(_numOfRelationship);
                                  _numOfRelationship++;
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                Text(
                                  "Thêm mối quan hệ",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                                Spacer(),
                                _listRelationship.isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(right: 5.sp),
                                        child: Text(
                                          "*",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.red),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 20.sp,
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
                                      .format(_enteredBirthday),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  width: 20.sp,
                                ),
                                DatePickerIcon(
                                    onPickDate: (datePick) =>
                                        _pickBirthday(datePick),
                                    selectedDate: _enteredBirthday),
                                Spacer(),
                                Icon(
                                  Icons.man_2_rounded,
                                  size: _enteredGender ? 30.sp : 40.sp,
                                  color: _enteredGender
                                      ? Colors.grey
                                      : Colors.blue,
                                ),
                                Switch(
                                  value: _enteredGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _enteredGender = value;
                                    });
                                  },
                                  activeColor: Colors.pink,
                                  inactiveThumbColor: Colors.blue,
                                  inactiveTrackColor: Colors.blue[200],
                                ),
                                Icon(
                                  Icons.woman_rounded,
                                  size: _enteredGender ? 40.sp : 30.sp,
                                  color: _enteredGender
                                      ? Colors.pink
                                      : Colors.grey,
                                ),
                              ],
                            ),
                            hr,
                            Column(
                              children: _listAddress.map((e) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _listAddress.remove(e);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Container(
                                          width: ScreenUtil().screenWidth * 0.6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              e.province!['name'] != null &&
                                                      e.district!['name'] !=
                                                          null &&
                                                      e.wards!['name'] != null
                                                  ? Text(
                                                      e.street != ''
                                                          ? "${e.street}, ${e.wards!['name']}, ${e.district!['name']}, ${e.province!['name']}"
                                                          : "${e.wards!['name']}, ${e.district!['name']}, ${e.province!['name']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    )
                                                  : SizedBox(),
                                              SizedBox(
                                                height:
                                                    e.province!['name'] !=
                                                                null &&
                                                            e.district![
                                                                    'name'] !=
                                                                null &&
                                                            e.wards!['name'] !=
                                                                null
                                                        ? 5
                                                        : 0,
                                              ),
                                              Text(
                                                e.type == 3 && e.name != null
                                                    ? e.name!
                                                    : showAddressTypeText(
                                                        e.type!),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        showAddressTypeIcon(e.type!, 20.sp),
                                        IconButton(
                                          onPressed: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeAddress(
                                                initAddress: e,
                                                onChangeAddress: (address) {
                                                  _changeAddress(e, address);
                                                },
                                              ),
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.arrow_right_outlined,
                                            color: Colors.grey,
                                            size: 25.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    hr,
                                  ],
                                );
                              }).toList(),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                  EdgeInsets.only(left: 8.sp),
                                ),
                              ),
                              onPressed: () {
                                if (_numOfAddress >= 3) {
                                  _numOfAddress = 0;
                                }
                                setState(() {
                                  if (_numOfAddress < 3) {
                                    _addAddress(_numOfAddress,
                                        showAddressTypeText(_numOfAddress));
                                    _numOfAddress++;
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  Text(
                                    "Thêm địa chỉ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            hr,
                            Row(
                              children: [
                                SizedBox(
                                  width: 10.sp,
                                ),
                                FaIcon(FontAwesomeIcons.solidHeart),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _enteredHobby,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Sở thích",
                                    ),
                                    onSaved: (value) {
                                      _enteredHobby = value!.trim();
                                    },
                                  ),
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
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _enteredPhone,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Số điện thoại",
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value != null &&
                                          value.isNotEmpty &&
                                          value.length != 10) {
                                        return "Vui lòng nhập số điện thoai hợp lệ.";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredPhone = value!.trim();
                                    },
                                  ),
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
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _enteredEmail,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textCapitalization: TextCapitalization.none,
                                    validator: (value) {
                                      if (value != null &&
                                          value.isNotEmpty &&
                                          !value.contains("@")) {
                                        return "Vui lòng nhập địa chỉ email hợp lệ.";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredEmail = value!.trim();
                                    },
                                  ),
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
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.sp),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _enteredFBName,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Tên tài khoản Facebook",
                                          ),
                                        ),
                                        hr,
                                        TextFormField(
                                          controller: _enteredFBLink,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Link tài khoản Facebook",
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isNotEmpty &&
                                                !Uri.parse(value).isAbsolute) {
                                              return "Vui lòng nhập link hợp lệ.";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: _searchFacebook,
                                    child: Stack(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.search,
                                          size: 25.sp,
                                        ),
                                        Positioned(
                                          bottom: 10.sp,
                                          right: 12.sp,
                                          child: FaIcon(
                                            FontAwesomeIcons.facebookF,
                                            size: 10.sp,
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                            hr,
                            Row(
                              children: [
                                SizedBox(
                                  width: 10.sp,
                                ),
                                FaIcon(FontAwesomeIcons.skype),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.sp),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _enteredSkypeName,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Tên tài khoản Skype",
                                          ),
                                        ),
                                        hr,
                                        TextFormField(
                                          controller: _enteredSkypeId,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Id Skype",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            hr,
                            Row(
                              children: [
                                SizedBox(
                                  width: 8.sp,
                                ),
                                Image.asset(
                                  'assets/images/icon-zalo.png',
                                  width: 25.sp,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.sp),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _enteredZaloName,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Tên tài khoản Zalo",
                                          ),
                                        ),
                                        hr,
                                        TextFormField(
                                          controller: _enteredZaloPhone,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Số điện thoại Zalo",
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value != null &&
                                                value.isNotEmpty &&
                                                value.length != 10) {
                                              return "Vui lòng nhập số điện thoai hợp lệ.";
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.sp,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: _getAllOtherInfo(),
                              ),
                              _isNewOtherInfo
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _enteredTitle.clear();
                                                  _enteredContent.clear();
                                                  _isNewOtherInfo = false;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    controller: _enteredTitle,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Tiêu đề",
                                                    ),
                                                  ),
                                                  hr,
                                                  TextFormField(
                                                    controller: _enteredContent,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Nội dung",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        hr,
                                      ],
                                    )
                                  : SizedBox(),
                              TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStatePropertyAll(
                                    EdgeInsets.only(left: 8.sp),
                                  ),
                                ),
                                onPressed: () {
                                  if (_isNewOtherInfo) {
                                    setState(() {
                                      _addOtherInfo(_enteredTitle.text.trim(),
                                          _enteredContent.text.trim());
                                      _enteredTitle.clear();
                                      _enteredContent.clear();
                                      _isNewOtherInfo = false;
                                    });
                                  } else {
                                    setState(() {
                                      _isNewOtherInfo = true;
                                    });
                                  }
                                },
                                child: _isNewOtherInfo
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Thêm thông tin này",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(
                                            Icons.add_circle,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 10.sp,
                                          ),
                                          Text(
                                            "Thêm thông tin khác",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

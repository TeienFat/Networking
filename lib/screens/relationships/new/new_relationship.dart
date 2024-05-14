import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_relationships.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/address_model.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/new/change_address.dart';
import 'package:networking/screens/relationships/new/change_relationship.dart';
import 'package:networking/screens/relationships/new/import_contacts.dart';
import 'package:networking/screens/relationships/new/qr_scan.dart';
import 'package:networking/widgets/date_picker.dart';
import 'package:networking/widgets/user_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tiengviet/tiengviet.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

final _uuid = Uuid();

class NewRelationship extends StatefulWidget {
  const NewRelationship({super.key})
      : this.user = null,
        this.relationships = null,
        this.fromImport = false;
  const NewRelationship.initUser(
      {super.key, required this.user, required this.relationships})
      : this.fromImport = false;
  const NewRelationship.fromImport(
      {super.key, required this.user, required this.relationships})
      : this.fromImport = true;
  final Users? user;
  final List<Relationship>? relationships;
  final bool fromImport;
  @override
  State<NewRelationship> createState() => _NewRelationshipState();
}

class _NewRelationshipState extends State<NewRelationship> {
  final _formKey = GlobalKey<FormState>();

  File? _enteredImageFile;

  var _enteredUserName;
  var _enteredPhone;
  var _enteredEmail;
  var _enteredHobby;
  var _enteredGender = false;

  TextEditingController _enteredTitle = TextEditingController();
  TextEditingController _enteredContent = TextEditingController();
  TextEditingController _enteredFBName = TextEditingController();
  TextEditingController _enteredFBLink = TextEditingController();
  TextEditingController _enteredSkypeName = TextEditingController();
  TextEditingController _enteredSkypeId = TextEditingController();
  TextEditingController _enteredZaloName = TextEditingController();
  TextEditingController _enteredZaloPhone = TextEditingController();

  DateTime _enteredBirthday = DateTime(2000, 01, 01);
  var _isNewOtherInfo = false;
  var _numOfRelationship = 0;
  var _numOfAddress = 0;
  List<Relationship> _listRelationship = [];
  List<Address> _listAddress = [];
  Map<String, dynamic> _otherInfo = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user != null) {
      if (widget.fromImport && widget.user!.imageUrl! != '') {
        _enteredImageFile = File(widget.user!.imageUrl!);
        print(_enteredImageFile!.path);
      }
      _enteredUserName = widget.user!.userName;
      _enteredPhone = widget.user!.phone;
      _enteredEmail = widget.user!.email;
      _enteredHobby = widget.user!.hobby;
      _enteredGender = widget.user!.gender!;

      if (widget.user!.facebook!.keys.first.isNotEmpty &&
          widget.user!.facebook!.keys.first != 'name')
        _enteredFBName.text = widget.user!.facebook!.keys.first;
      if (widget.user!.facebook!.values.first.isNotEmpty &&
          widget.user!.facebook!.values.first != 'link')
        _enteredFBLink.text = widget.user!.facebook!.values.first;

      if (widget.user!.skype!.keys.first.isNotEmpty &&
          widget.user!.skype!.keys.first != 'name')
        _enteredSkypeName.text = widget.user!.skype!.keys.first;
      if (widget.user!.skype!.values.first.isNotEmpty &&
          widget.user!.skype!.values.first != 'id')
        _enteredSkypeId.text = widget.user!.skype!.values.first;

      if (widget.user!.zalo!.keys.first.isNotEmpty &&
          widget.user!.zalo!.keys.first != 'name')
        _enteredZaloName.text = widget.user!.zalo!.keys.first;
      if (widget.user!.zalo!.values.first.isNotEmpty &&
          widget.user!.zalo!.values.first != 'phone')
        _enteredZaloPhone.text = widget.user!.zalo!.values.first;

      _enteredBirthday = widget.user!.birthday!;
      _numOfRelationship = widget.relationships!.length;
      _numOfAddress = widget.user!.address!.length;
      _listRelationship = widget.relationships!;
      _listAddress = widget.user!.address!;
      _otherInfo = widget.user!.otherInfo!;
    }
  }

  void _createNewRelationship() async {
    final isValid = _formKey.currentState!.validate();
    final userId = _uuid.v4();
    if (!isValid) {
      return;
    } else {
      if (_listRelationship.isNotEmpty) {
        final checkNamesake = await checkContainsUserName(_enteredUserName);

        String imageUrl;
        Map<String, String> _enteredFacebook = {
          _enteredFBName.text.trim(): _enteredFBLink.text.trim()
        };
        Map<String, String> _enteredSkype = {
          _enteredSkypeName.text.trim(): _enteredSkypeId.text.trim()
        };
        Map<String, String> _enteredZalo = {
          _enteredZaloName.text.trim(): _enteredZaloPhone.text.trim()
        };
        String? meId = await APIsAuth.getCurrentUserId();
        if (checkNamesake) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Icon(
                Icons.warning_rounded,
                size: 50.sp,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Có vẻ như ',
                      style: TextStyle(
                          color: Colors.black, fontSize: 14.sp, height: 1.3.sp),
                      children: <TextSpan>[
                        TextSpan(
                          text: _enteredUserName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' đã có trong danh sách các mối quan hệ của bạn.',
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.5.sp,
                  ),
                  Text(
                    "Bạn vẫn muốn thêm mối quan hệ này?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Hủy"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () async {
                    if (_enteredImageFile != null) {
                      imageUrl = await APIsUser.saveUserImage(
                          _enteredImageFile!, '$userId.jpg');
                    } else {
                      if (widget.user != null && widget.user!.imageUrl != '') {
                        final response =
                            await http.get(Uri.parse(widget.user!.imageUrl!));
                        final documentDirectory =
                            await getApplicationDocumentsDirectory();
                        String Url = '${documentDirectory.path}/$userId.jpg';
                        final file = File(Url);
                        file.writeAsBytesSync(response.bodyBytes);
                        imageUrl = file.path;
                        print(file.path);
                      } else {
                        imageUrl = '';
                      }
                    }
                    context.read<UserListBloc>().add(AddUser(
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
                    context.read<UsReListBloc>().add(AddUsRe(
                        meId: meId!,
                        myReId: userId,
                        userName: _enteredUserName,
                        birthday: _enteredBirthday,
                        imageUrl: imageUrl,
                        relationships: _listRelationship));
                    showSnackbar(
                      context,
                      "Đã thêm mối quan hệ mới",
                      Duration(seconds: 3),
                      true,
                    );
                    Navigator.of(context).pushReplacementNamed("/Main");
                  },
                  child: Text("Thêm"),
                ),
              ],
            ),
          );
        } else {
          if (_enteredImageFile != null) {
            imageUrl =
                await APIsUser.saveUserImage(_enteredImageFile!, '$userId.jpg');
          } else {
            if (widget.user != null && widget.user!.imageUrl != '') {
              final response =
                  await http.get(Uri.parse(widget.user!.imageUrl!));
              final documentDirectory =
                  await getApplicationDocumentsDirectory();
              String Url = '${documentDirectory.path}/$userId.jpg';
              final file = File(Url);
              file.writeAsBytesSync(response.bodyBytes);
              imageUrl = file.path;
              print(file.path);
            } else {
              imageUrl = '';
            }
          }
          context.read<UserListBloc>().add(AddUser(
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
          context.read<UsReListBloc>().add(AddUsRe(
              meId: meId!,
              myReId: userId,
              userName: _enteredUserName,
              birthday: _enteredBirthday,
              imageUrl: imageUrl,
              relationships: _listRelationship));

          showSnackbar(
              context, "Đã thêm mối quan hệ mới", Duration(seconds: 2), true);
          Navigator.of(context).pushReplacementNamed("/Main");
        }
      } else {
        showSnackbar(context, "Vui lòng thiết lập mối quan hệ",
            Duration(seconds: 2), false);
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

  static Future<bool> checkContainsUserName(String userName) async {
    List<UserRelationship> listUsRe = await APIsUsRe.getAllMyRelationship();
    List<Users> listUser = [];
    for (var usRe in listUsRe) {
      Users? user = await APIsUser.getUserFromId(usRe.myRelationShipId!);
      if (user != null) {
        listUser.add(user);
      }
    }
    for (var u in listUser) {
      if ((TiengViet.parse(u.userName!).length ==
              TiengViet.parse(userName).length) &&
          (TiengViet.parse(u.userName!).toLowerCase() ==
              TiengViet.parse(userName).toLowerCase())) {
        return true;
      }
    }
    return false;
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
          Duration(seconds: 2), false);
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
        title: Text("Mối quan hệ mới"),
        centerTitle: true,
        actions: [
          if (widget.user == null)
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.contacts,
                color: Colors.black,
                size: 25.sp,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImportContacts(),
                    ));
              },
            ),
          if (widget.user == null)
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.qr_code_scanner_outlined,
                color: Colors.black,
                size: 25.sp,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRScan(),
                    ));
              },
            ),
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
                      initNetworkImage: !widget.fromImport &&
                              widget.user != null &&
                              widget.user!.imageUrl != ''
                          ? widget.user!.imageUrl!
                          : null,
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
                                  selectedDate: _enteredBirthday,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  helpText: "Chọn ngày sinh",
                                  fieldText: "Ngày sinh",
                                ),
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
                                  width: 5.sp,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[400],
        onPressed: () {
          _formKey.currentState!.save();
          _createNewRelationship();
        },
        child: Icon(
          Icons.save_rounded,
          color: Colors.black,
          size: 35.sp,
        ),
      ),
    );
  }
}

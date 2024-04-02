import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_relationships.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_model.dart';

class ChangeRelationship extends StatefulWidget {
  const ChangeRelationship(
      {super.key,
      required this.relationshipID,
      required this.onChangeRelationship});
  final String relationshipID;
  final Function(Relationship relationship) onChangeRelationship;
  @override
  State<ChangeRelationship> createState() => _ChangeRelationshipState();
}

class _ChangeRelationshipState extends State<ChangeRelationship> {
  var _isNewRelationship = false;
  TextEditingController _enteredRelationshipName = TextEditingController();
  int? _enteredRelationshipType;
  void _onSelect(Relationship relationship) {
    widget.onChangeRelationship(relationship);
    Navigator.of(context).pop();
  }

  void _newRelationship() async {
    if (_enteredRelationshipName.text.isNotEmpty &&
        _enteredRelationshipType != null) {
      _onSelect(await APIsRelationship.createNewRelationship(
          _enteredRelationshipName.text, _enteredRelationshipType!));
    }
    Navigator.of(context).pop();
  }

  Widget _hr = Divider(
    color: Colors.grey[300],
    thickness: 1.5.sp,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _isNewRelationship
              ? TextButton(
                  onPressed: _newRelationship,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.sp),
                    child: Text(
                      "Xong",
                      style: TextStyle(
                        color: Colors.blue[400],
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: APIsRelationship.getAllRelationship(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: Text("Đang load"));
            // }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Column(
                children: [
                  Text("Không có mối quan hệ nào"),
                ],
              ));
            }
            if (snapshot.hasError) {
              return Center(child: Text("Có gì đó sai sai..."));
            }
            final relationships = snapshot.data!;
            var _listGiaDinh =
                relationships.where((element) => element.type! == 0);
            var _listTinhYeu =
                relationships.where((element) => element.type! == 1);
            var _listCongViec =
                relationships.where((element) => element.type! == 2);
            var _listBanBe =
                relationships.where((element) => element.type! == 3);
            var _listHocTap =
                relationships.where((element) => element.type! == 4);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.sp),
                    child: Row(
                      children: [
                        Text(
                          "Gia Đình",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16.sp),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        showRelationshipTypeIcon(0, 15.sp),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      children: _listGiaDinh.map((e) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 5.sp,
                            ),
                            TextButton(
                              onPressed: () => _onSelect(e),
                              child: Row(
                                children: [
                                  Text(
                                    e.name!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Spacer(),
                                  widget.relationshipID.length ==
                                              e.relationshipId!.length &&
                                          widget.relationshipID ==
                                              e.relationshipId!
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.blue[400],
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                ],
                              ),
                            ),
                            e != _listGiaDinh.last ? _hr : SizedBox()
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.sp),
                    child: Row(
                      children: [
                        Text(
                          "Tình Yêu",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16.sp),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        showRelationshipTypeIcon(1, 15.sp),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      children: _listTinhYeu.map((e) {
                        return Column(
                          children: [
                            TextButton(
                              onPressed: () => _onSelect(e),
                              child: Row(
                                children: [
                                  Text(
                                    e.name!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Spacer(),
                                  widget.relationshipID.length ==
                                              e.relationshipId!.length &&
                                          widget.relationshipID ==
                                              e.relationshipId!
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.blue[400],
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                ],
                              ),
                            ),
                            e != _listTinhYeu.last ? _hr : SizedBox()
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.sp),
                    child: Row(
                      children: [
                        Text(
                          "Công Việc",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16.sp),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        showRelationshipTypeIcon(2, 15.sp),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      children: _listCongViec.map((e) {
                        return Column(
                          children: [
                            TextButton(
                              onPressed: () => _onSelect(e),
                              child: Row(
                                children: [
                                  Text(
                                    e.name!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Spacer(),
                                  widget.relationshipID.length ==
                                              e.relationshipId!.length &&
                                          widget.relationshipID ==
                                              e.relationshipId!
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.blue[400],
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                ],
                              ),
                            ),
                            e != _listCongViec.last ? _hr : SizedBox()
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.sp),
                    child: Row(
                      children: [
                        Text(
                          "Bạn Bè",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16.sp),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        showRelationshipTypeIcon(3, 15.sp),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      children: _listBanBe.map((e) {
                        return Column(
                          children: [
                            TextButton(
                              onPressed: () => _onSelect(e),
                              child: Row(
                                children: [
                                  Text(
                                    e.name!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Spacer(),
                                  widget.relationshipID.length ==
                                              e.relationshipId!.length &&
                                          widget.relationshipID ==
                                              e.relationshipId!
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.blue[400],
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                ],
                              ),
                            ),
                            e != _listBanBe.last ? _hr : SizedBox()
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.sp),
                    child: Row(
                      children: [
                        Text(
                          "Học Tập",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16.sp),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        showRelationshipTypeIcon(4, 15.sp),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      children: _listHocTap.map((e) {
                        return Column(
                          children: [
                            TextButton(
                              onPressed: () => _onSelect(e),
                              child: Row(
                                children: [
                                  Text(
                                    e.name!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  Spacer(),
                                  widget.relationshipID.length ==
                                              e.relationshipId!.length &&
                                          widget.relationshipID ==
                                              e.relationshipId!
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.blue[400],
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                ],
                              ),
                            ),
                            e != _listHocTap.last ? _hr : SizedBox()
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  !_isNewRelationship
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isNewRelationship = true;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Tạo mối quan hệ khác",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ))
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _enteredRelationshipName,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Tên mối quan hệ",
                                  ),
                                ),
                              ),
                              Container(
                                width: ScreenUtil().screenWidth / 2.5,
                                child: DropdownButtonFormField<int>(
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  isExpanded: false,
                                  menuMaxHeight: 100.sp,
                                  dropdownColor: Colors.grey[100],
                                  hint: Text(
                                    'Quan hệ',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          showRelationshipTypeIcon(0, 14.sp),
                                          SizedBox(
                                            width: 10.sp,
                                          ),
                                          Text(
                                            "Gia Đình",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 0,
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          showRelationshipTypeIcon(1, 14.sp),
                                          SizedBox(
                                            width: 10.sp,
                                          ),
                                          Text(
                                            "Tình Yêu",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          showRelationshipTypeIcon(2, 14.sp),
                                          SizedBox(
                                            width: 10.sp,
                                          ),
                                          Text(
                                            "Công Việc",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 2,
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          showRelationshipTypeIcon(3, 14.sp),
                                          SizedBox(
                                            width: 10.sp,
                                          ),
                                          Text(
                                            "Bạn Bè",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 3,
                                    ),
                                    DropdownMenuItem(
                                      child: Row(
                                        children: [
                                          showRelationshipTypeIcon(4, 14.sp),
                                          SizedBox(
                                            width: 10.sp,
                                          ),
                                          Text(
                                            "Học Tập",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: 4,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }
                                    setState(() {
                                      _enteredRelationshipType = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Vui lòng chọn mối quan hệ.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10.sp,
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 20.sp,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

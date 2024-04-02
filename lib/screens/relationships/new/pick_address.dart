import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/models/district_model.dart';
import 'package:networking/models/province_model.dart';
import 'package:networking/models/wards_model.dart';

class PickAddress extends StatefulWidget {
  const PickAddress(
      {super.key,
      required this.onPickAddress,
      required this.initProvince,
      required this.initDistrict,
      required this.initWards});
  final Province? initProvince;
  final District? initDistrict;
  final Wards? initWards;

  final Function(Province province, District district, Wards wards)
      onPickAddress;
  @override
  State<PickAddress> createState() => _PickAddressState();
}

class _PickAddressState extends State<PickAddress> {
  String? _enteredProvinceName;
  String? _enteredDistrictName;
  String? _enteredWardsName;
  String? _enteredProvinceId;
  String? _enteredDistrictId;
  String? _enteredWardsId;

  var _isPickType;

  Future<String> _loadADataAsset() async {
    return await rootBundle.loadString('assets/data.json');
  }

  Future<List<Province>> _loadProvince() async {
    List<Province> listProvince;
    String jsonString = await _loadADataAsset();
    final jsonResponse = jsonDecode(jsonString);
    var list = jsonResponse.map((e) => Province.fromJson(e)).toList();
    listProvince = new List<Province>.from(list);
    return listProvince;
  }

  Future<List<District>> _loadDistrict(String provinceId) async {
    List<District> listDistrict;
    List<Province> listProvince = await _loadProvince();
    var index = listProvince.indexWhere((element) => element.id == provinceId);
    Province province = listProvince.elementAt(index);
    listDistrict =
        province.districts!.map((e) => District.fromJson(e)).toList();

    return listDistrict;
  }

  Future<List<Wards>> _loadWards(String provinceId, String districtId) async {
    List<Wards> listWards;
    List<District> listDistrict = await _loadDistrict(provinceId);
    var index = listDistrict.indexWhere((element) => element.id == districtId);
    District district = listDistrict.elementAt(index);
    listWards = district.wards!.map((e) => Wards.fromJson(e)).toList();

    return listWards;
  }

  Widget _hr = Divider(
    color: Colors.grey[300],
    thickness: 1.5.sp,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initProvince != null &&
        widget.initDistrict != null &&
        widget.initWards != null) {
      _enteredProvinceId = widget.initProvince!.id;
      _enteredProvinceName = widget.initProvince!.name;
      _enteredDistrictId = widget.initDistrict!.id;
      _enteredDistrictName = widget.initDistrict!.name;
      _enteredWardsId = widget.initWards!.id;
      _enteredWardsName = widget.initWards!.name;
    }
    _isPickType = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              widget.onPickAddress(
                  Province(
                      id: _enteredProvinceId,
                      name: _enteredProvinceName,
                      districts: []),
                  District(
                      id: _enteredDistrictId,
                      name: _enteredDistrictName,
                      wards: []),
                  Wards(
                      id: _enteredWardsId, name: _enteredWardsName, level: ''));
              Navigator.of(context).pop();
            },
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
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(5.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20.sp,
                    ),
                    Text(
                      "Khu vực được chọn",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _enteredProvinceName = null;
                          _enteredDistrictName = null;
                          _enteredWardsName = null;
                          _enteredProvinceId = null;
                          _enteredDistrictId = null;
                          _enteredWardsId = null;
                          _isPickType = 0;
                        });
                      },
                      child: Text(
                        "Thiết lập lại",
                        style: TextStyle(
                            fontSize: 14.sp, color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.sp),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _enteredProvinceName != null
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isPickType = 0;
                                    _enteredDistrictName = null;
                                    _enteredWardsName = null;
                                    _enteredDistrictId = null;
                                    _enteredWardsId = null;
                                  });
                                },
                                child: Text(
                                  _enteredProvinceName!,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: _isPickType == 0
                                          ? Colors.orange[800]
                                          : null),
                                ),
                              )
                            : SizedBox(),
                        _enteredDistrictName != null
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _enteredWardsName = null;
                                    _enteredWardsId = null;
                                    _isPickType = 1;
                                  });
                                },
                                child: Text(
                                  _enteredDistrictName!,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: _isPickType == 1
                                          ? Colors.orange[800]
                                          : null),
                                ),
                              )
                            : SizedBox(),
                        _enteredWardsName != null
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isPickType = 2;
                                  });
                                },
                                child: Text(
                                  _enteredWardsName!,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: _isPickType == 2
                                          ? Colors.orange[800]
                                          : null),
                                ),
                              )
                            : SizedBox(),
                      ]),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: Text(
                    _isPickType == 0
                        ? "Tỉnh/Thành phố"
                        : _isPickType == 1
                            ? "Quận/Huyện"
                            : "Phường/Xã",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
                SizedBox(
                  height: 5.sp,
                ),
                _isPickType == 0
                    ? FutureBuilder(
                        future: _loadProvince(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center();
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("Có gì đó sai sai..."));
                          }
                          List<Province> _listProvince = snapshot.data!;
                          return Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 30.sp),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _enteredProvinceName =
                                                _listProvince[index].name!;
                                            _enteredProvinceId =
                                                _listProvince[index].id!;
                                            _isPickType = 1;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              _listProvince[index].name!,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: _enteredProvinceId ==
                                                        _listProvince[index].id!
                                                    ? Colors.orange[800]
                                                    : null,
                                              ),
                                            ),
                                            Spacer(),
                                            _enteredProvinceId ==
                                                    _listProvince[index].id!
                                                ? Icon(
                                                    Icons.check,
                                                    color: Colors.orange[800],
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    _hr,
                                  ],
                                );
                              },
                              itemCount: _listProvince.length,
                            ),
                          );
                        },
                      )
                    : _isPickType == 1
                        ? FutureBuilder(
                            future: _loadDistrict(_enteredProvinceId!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center();
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text("Có gì đó sai sai..."));
                              }
                              List<District> _listDistrict = snapshot.data!;
                              return Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 30.sp),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _enteredDistrictName =
                                                    _listDistrict[index].name!;
                                                _enteredDistrictId =
                                                    _listDistrict[index].id!;
                                                _isPickType = 2;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  _listDistrict[index].name!,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: _enteredDistrictId ==
                                                            _listDistrict[index]
                                                                .id!
                                                        ? Colors.orange[800]
                                                        : null,
                                                  ),
                                                ),
                                                Spacer(),
                                                _enteredDistrictId ==
                                                        _listDistrict[index].id!
                                                    ? Icon(
                                                        Icons.check,
                                                        color:
                                                            Colors.orange[800],
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        _hr,
                                      ],
                                    );
                                  },
                                  itemCount: _listDistrict.length,
                                ),
                              );
                            },
                          )
                        : FutureBuilder(
                            future: _loadWards(
                                _enteredProvinceId!, _enteredDistrictId!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center();
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text("Có gì đó sai sai..."));
                              }
                              List<Wards> _listWards = snapshot.data!;
                              return Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 30.sp),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _enteredWardsName =
                                                    _listWards[index].name!;
                                                _enteredWardsId =
                                                    _listWards[index].id!;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  _listWards[index].name!,
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: _enteredWardsId ==
                                                            _listWards[index]
                                                                .id!
                                                        ? Colors.orange[800]
                                                        : null,
                                                  ),
                                                ),
                                                Spacer(),
                                                _enteredWardsId ==
                                                        _listWards[index].id!
                                                    ? Icon(
                                                        Icons.check,
                                                        color:
                                                            Colors.orange[800],
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        _hr,
                                      ],
                                    );
                                  },
                                  itemCount: _listWards.length,
                                ),
                              );
                            },
                          ),
              ],
            )),
      ),
    );
  }
}

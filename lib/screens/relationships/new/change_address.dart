import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/address_model.dart';
import 'package:networking/models/district_model.dart';
import 'package:networking/models/province_model.dart';
import 'package:networking/models/wards_model.dart';
import 'package:networking/screens/relationships/new/pick_address.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress(
      {super.key, required this.initAddress, required this.onChangeAddress});
  final Address? initAddress;
  final Function(Address address) onChangeAddress;
  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  var _isNewAddress = false;
  var _isNewAddressType = false;
  var _enteredAddressType;
  TextEditingController _enteredStreet = TextEditingController();
  TextEditingController _enteredAddressName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Province? _selectedProvince;
  District? _selectedDistrict;
  Wards? _selectedWards;

  Widget _hr = Divider(
    color: Colors.grey[300],
    thickness: 1.5.sp,
  );

  void _onPickAddress(Province province, District district, Wards wards) {
    setState(() {
      _selectedProvince = province;
      _selectedDistrict = district;
      _selectedWards = wards;
      _isNewAddress = true;
    });
  }

  void _onCreateNewAddress() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      if (_selectedProvince!.id != null &&
          _selectedProvince!.name != null &&
          _selectedDistrict!.id != null &&
          _selectedDistrict!.name != null &&
          _selectedWards!.id != null &&
          _selectedWards!.name != null) {
        Address address = Address(
            province: {
              'id': _selectedProvince!.id!,
              'name': _selectedProvince!.name!
            },
            district: {
              'id': _selectedDistrict!.id!,
              'name': _selectedDistrict!.name!
            },
            wards: {
              'id': _selectedWards!.id!,
              'name': _selectedWards!.name!
            },
            street: _enteredStreet.text.trim(),
            name: _enteredAddressName.text.trim(),
            type: _enteredAddressType);
        widget.onChangeAddress(address);
        Navigator.of(context).pop();
      } else {
        showSnackbar(context, 'Vui lòng chọn địa chỉ', Duration(seconds: 3),
            false, ScreenUtil().screenHeight - 120);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var address = widget.initAddress;
    if (address != null) {
      _enteredAddressType = address.type;
      _enteredAddressName.text = address.name!;
      _enteredStreet.text = address.street!;
      _selectedProvince = Province(
          id: address.province!['id'],
          name: address.province!['name'],
          districts: []);
      _selectedDistrict = District(
          id: address.district!['id'],
          name: address.district!['name'],
          wards: []);
      _selectedWards = Wards(
          id: address.wards!['id'], name: address.wards!['name'], level: '');
      if (address.type == 3) _isNewAddressType = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _isNewAddress
              ? TextButton(
                  onPressed: () {
                    _onCreateNewAddress();
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
              : SizedBox(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5.sp),
          child: Column(
            children: [
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.sp,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => PickAddress(
                                          initProvince: _selectedProvince,
                                          initDistrict: _selectedDistrict,
                                          initWards: _selectedWards,
                                          onPickAddress:
                                              (province, district, wards) {
                                            _onPickAddress(
                                                province, district, wards);
                                          },
                                        )),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: ScreenUtil().screenWidth * 0.8,
                                  child: Text(
                                    _selectedProvince!.name != null &&
                                            _selectedDistrict!.name != null &&
                                            _selectedWards!.name != null
                                        ? "${_selectedWards!.name}, ${_selectedDistrict!.name}, ${_selectedProvince!.name}"
                                        : "Tỉnh/Thành phố, Quận/Huyện, Phường/Xã",
                                    style: TextStyle(fontSize: 14.sp),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right_outlined,
                                  color: Colors.grey,
                                  size: 25.sp,
                                ),
                              ],
                            )),
                      ],
                    ),
                    _hr,
                    TextField(
                      controller: _enteredStreet,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Tên đường, tòa nhà, số nhà",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isNewAddress = true;
                        });
                      },
                      onTap: () {
                        setState(() {
                          _isNewAddress = true;
                        });
                      },
                    ),
                    _hr,
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _enteredAddressName,
                              enabled: _isNewAddressType,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _enteredAddressName.text == ''
                                    ? 'Nhập loại địa chỉ'
                                    : _enteredAddressName.text,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Vui lòng nhập tên loại địa chỉ.";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredAddressName.text = newValue!.trim();
                              },
                              onChanged: (value) {
                                setState(() {
                                  _isNewAddress = true;
                                });
                              },
                              onTap: () {
                                setState(() {
                                  _isNewAddress = true;
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().screenWidth / 2.5,
                          child: DropdownButtonFormField<int>(
                            value: _enteredAddressType,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            isExpanded: false,
                            menuMaxHeight: 100.sp,
                            dropdownColor: Colors.grey[100],
                            items: [
                              DropdownMenuItem(
                                child: Row(
                                  children: [
                                    showAddressTypeIcon(0, 14.sp),
                                    SizedBox(
                                      width: 10.sp,
                                    ),
                                    Text(
                                      showAddressTypeText(0),
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
                                    showAddressTypeIcon(1, 14.sp),
                                    SizedBox(
                                      width: 10.sp,
                                    ),
                                    Text(
                                      showAddressTypeText(1),
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
                                    showAddressTypeIcon(2, 14.sp),
                                    SizedBox(
                                      width: 10.sp,
                                    ),
                                    Text(
                                      showAddressTypeText(2),
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
                                    showAddressTypeIcon(3, 14.sp),
                                    SizedBox(
                                      width: 10.sp,
                                    ),
                                    Text(
                                      showAddressTypeText(3),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                value: 3,
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _isNewAddress = true;
                              });
                              if (value == null) {
                                return;
                              } else {
                                _enteredAddressType = value;
                                if (value == 3) {
                                  setState(() {
                                    _enteredAddressName.text = '';
                                    _isNewAddressType = true;
                                  });
                                } else {
                                  setState(() {
                                    _enteredAddressName.text =
                                        showAddressTypeText(value);
                                    _isNewAddressType = false;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
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

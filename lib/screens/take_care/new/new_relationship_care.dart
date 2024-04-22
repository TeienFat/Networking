import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/widgets/date_picker.dart';
import 'package:networking/widgets/pick_relationship.dart';
import 'package:networking/widgets/time_picker.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class NewRelationshipCare extends StatefulWidget {
  const NewRelationshipCare({super.key}) : userRelationship = null;
  const NewRelationshipCare.fromUsRe(
      {super.key, required this.userRelationship});
  final UserRelationship? userRelationship;
  @override
  State<NewRelationshipCare> createState() => _NewRelationshipCareState();
}

class _NewRelationshipCareState extends State<NewRelationshipCare> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle;
  var _enteredUsReId;
  // var _usReName;
  // var _usReRelationship;
  var _enteredAllDay = false;
  TimeOfDay _enteredStartTime =
      TimeOfDay(hour: TimeOfDay.now().hour, minute: 0);
  TimeOfDay _enteredEndTime =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
  DateTime _enteredStartDay = DateTime.now();
  DateTime _enteredEndDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.userRelationship != null) {
      _enteredUsReId = widget.userRelationship!.usReId;
    }
  }

  void _createNewRelationshipCare() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_enteredUsReId != '') {
      final startTime = _enteredStartDay.copyWith(
          hour: _enteredStartTime.hour,
          minute: _enteredStartTime.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0);
      final endTime = _enteredEndDay.copyWith(
          hour: _enteredEndTime.hour,
          minute: _enteredEndTime.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0);
      String? meId = await APIsAuth.getCurrentUserId();
      context.read<ReCareListBloc>().add(AddReCare(
          meId: meId!,
          usReId: _enteredUsReId,
          startTime: startTime,
          endTime: endTime,
          title: _enteredTitle));
      if (widget.userRelationship != null) {
        showSnackbar(context, "Đã thêm mục chăm sóc mới", Duration(seconds: 2),
            true, ScreenUtil().screenHeight - 150.sp);
      } else {
        showSnackbar(context, "Đã thêm mục chăm sóc mới", Duration(seconds: 2),
            true, ScreenUtil().screenHeight - 150.sp);
      }

      Navigator.of(context).pop();
    } else {
      showSnackbar(context, "Hãy chọn mối quan hệ cần chăm sóc",
          Duration(seconds: 2), false, ScreenUtil().screenHeight - 180);
      return;
    }
  }

  void _pickStartTime(TimeOfDay time) {
    setState(() {
      _enteredStartTime = time;
    });
  }

  void _pickEndTime(TimeOfDay time) {
    setState(() {
      _enteredEndTime = time;
    });
  }

  void _setAllDay(bool value) {
    if (value) {
      setState(() {
        _enteredStartTime = TimeOfDay(hour: 0, minute: 0);
        _enteredEndTime = TimeOfDay(hour: 23, minute: 59);
      });
    }
  }

  void onPickRelationship(String usReId) {
    _enteredUsReId = usReId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm chăm sóc"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              _formKey.currentState!.save();
              _createNewRelationshipCare();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.sp),
              child: Text(
                "Thêm",
                style: TextStyle(color: Colors.blue[800]),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 20.sp),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    child: Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tiêu đề",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Tiêu đề không được để trống.";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredTitle = value!.trim();
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5.sp),
                            child: Text(
                              "*",
                              style:
                                  TextStyle(fontSize: 18.sp, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  widget.userRelationship != null
                      ? Container(
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
                            child: BlocBuilder<UserListBloc, UserListState>(
                              builder: (context, state) {
                                if (state is UserListUploaded &&
                                    state.users.isNotEmpty) {
                                  final users = state.users;
                                  for (var user in users) {
                                    if ((user.userId!.length ==
                                            widget.userRelationship!
                                                .myRelationShipId!.length) &&
                                        (user.userId ==
                                            widget.userRelationship!
                                                .myRelationShipId!)) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.sp),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.userName!,
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(
                                                  height: 5.sp,
                                                ),
                                                Row(
                                                  children: getRowRelationship(
                                                      widget.userRelationship!
                                                          .relationships!,
                                                      2,
                                                      12.sp,
                                                      12.sp),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  }
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        )
                      : PickRelationship(
                          onPickRelationship: (usReId) =>
                              onPickRelationship(usReId),
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
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cả ngày",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                Switch(
                                  value: _enteredAllDay,
                                  onChanged: (value) {
                                    setState(() {
                                      _enteredAllDay = value;
                                      _setAllDay(_enteredAllDay);
                                    });
                                  },
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          hr,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: ScreenUtil().screenWidth * 0.2,
                                  child: Text(
                                    "Bắt đầu",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _enteredStartTime.format(context),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: _enteredAllDay
                                              ? Colors.grey
                                              : null),
                                    ),
                                    TimePickerIcon(
                                        onPickTime: (timePick) =>
                                            _pickStartTime(timePick),
                                        selectedTime: _enteredStartTime,
                                        helpText: 'Chọn giờ bắt đầu',
                                        disabled: _enteredAllDay),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(_enteredStartDay),
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    DatePickerIcon(
                                      onPickDate: (datePick) {
                                        setState(() {
                                          _enteredStartDay = datePick;
                                          if (datePick
                                              .isAfter(_enteredEndDay)) {
                                            _enteredEndDay = datePick;
                                          }
                                        });
                                      },
                                      selectedDate: _enteredStartDay,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2124),
                                      helpText: "Chọn ngày bắt đầu",
                                      fieldText: "Ngày bắt đầu",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          hr,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: ScreenUtil().screenWidth * 0.2,
                                  child: Text(
                                    "Kết thúc",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _enteredEndTime.format(context),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: _enteredAllDay
                                              ? Colors.grey
                                              : null),
                                    ),
                                    TimePickerIcon(
                                        onPickTime: (timePick) =>
                                            _pickEndTime(timePick),
                                        selectedTime: _enteredEndTime,
                                        helpText: 'Chọn giờ kết thúc',
                                        disabled: _enteredAllDay),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(_enteredEndDay),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                    DatePickerIcon(
                                      onPickDate: (datePick) {
                                        setState(() {
                                          _enteredEndDay = datePick;
                                        });
                                      },
                                      selectedDate: _enteredEndDay,
                                      firstDate: _enteredStartDay,
                                      lastDate: DateTime(2124),
                                      helpText: "Chọn ngày kết thúc",
                                      fieldText: "Ngày kết thúc",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[400],
        onPressed: () {},
        child: Icon(
          Icons.calendar_month_outlined,
          color: Colors.black,
          size: 35.sp,
        ),
      ),
    );
  }
}

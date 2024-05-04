import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/take_care/detail/list_Image.dart';
import 'package:networking/screens/take_care/detail/scale_image.dart';
import 'package:networking/screens/take_care/edit/evaluate.dart';
import 'package:networking/widgets/menu_pick_image.dart';

class DetailRelationshipCare extends StatefulWidget {
  const DetailRelationshipCare(
      {super.key,
      required this.reCare,
      required this.userRelationship,
      required this.route})
      : fromNotification = false;
  const DetailRelationshipCare.fromNotification(
      {super.key,
      required this.reCare,
      required this.userRelationship,
      required this.route})
      : fromNotification = true;
  final RelationshipCare reCare;
  final UserRelationship userRelationship;
  final bool fromNotification;
  final bool route;
  @override
  State<DetailRelationshipCare> createState() => _DetailRelationshipCareState();
}

class _DetailRelationshipCareState extends State<DetailRelationshipCare> {
  TextEditingController _contentTextController = TextEditingController();
  List<File> _listFileImage = [];
  var _isShowNote;
  var _isChangeText = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.reCare.contentText != '') {
      _contentTextController.text = widget.reCare.contentText!;
      _isShowNote = true;
    } else {
      _isShowNote = false;
    }

    if (widget.route) {
      widget.reCare.isFinish = -1;
      _listFileImage = widget.reCare.contentImage!.map((e) => File(e)).toList();
    }
  }

  void _addContentText() {
    context.read<ReCareListBloc>().add(AddContentText(
        reCareId: widget.reCare.reCareId!,
        contentText: _contentTextController.text.trim()));
  }

  void _pickImage(bool pickerType) async {
    var pickedImage;
    String imageUrl;
    var time = DateTime.now().microsecondsSinceEpoch;
    if (pickerType) {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      if (pickedImage == null) {
        return;
      }
      imageUrl = await APIsUser.saveUserImage(File(pickedImage.path),
          '${widget.reCare.reCareId! + '-T' + time.toString()}.jpg');
      context.read<ReCareListBloc>().add(AddContentImage(
          reCareId: widget.reCare.reCareId!, imageUrl: imageUrl));
      if (widget.route) {
        setState(() {
          _listFileImage.add(File(imageUrl));
        });
      }
    } else {
      pickedImage = await ImagePicker().pickMultiImage(
        imageQuality: 100,
      );
      if (pickedImage == null) {
        return;
      }
      for (int i = 0; i < pickedImage.length; i++) {
        imageUrl = await APIsUser.saveUserImage(File(pickedImage[i].path),
            '${widget.reCare.reCareId! + '-T' + i.toString() + time.toString()}.jpg');
        context.read<ReCareListBloc>().add(AddContentImage(
            reCareId: widget.reCare.reCareId!, imageUrl: imageUrl));
        if (widget.route) {
          setState(() {
            _listFileImage.add(File(imageUrl));
          });
        }
      }
    }
  }

  void _removeImage(String imageUrl) {
    File(imageUrl).delete();
    context.read<ReCareListBloc>().add(RemoveContentImage(
        reCareId: widget.reCare.reCareId!, imageUrl: imageUrl));
  }

  void _onEvaluate(bool isSuccess) async {
    setState(() {
      widget.reCare.isFinish = isSuccess ? 1 : 0;
      context.read<ReCareListBloc>().add(UpdateIsFinish(
          reCareId: widget.reCare.reCareId!, isFinish: isSuccess ? 1 : 0));
    });
    await APIsReCare.getNumSuccess(widget.userRelationship.usReId!);
    final timeOfCare =
        await APIsReCare.getNumSuccess(widget.userRelationship.usReId!);
    context.read<UsReListBloc>().add(UpdateTimeOfCareUsRe(
        usReId: widget.userRelationship.usReId!, timeOfCare: timeOfCare));
  }

  Widget build(BuildContext context) {
    Color _bgCardColor;
    String _status;
    switch (widget.reCare.isFinish) {
      case 1:
        _bgCardColor = Colors.green[200]!;
        _status = 'Đã hoàn thành chăm sóc';

        break;
      case 2:
        _bgCardColor = Colors.amber[100]!;

        _status = 'Đang chờ chăm sóc';
      case 0:
        _bgCardColor = Colors.red[200]!;
        _status = 'Không hoàn thành chăm sóc';
        break;

      default:
        _bgCardColor = Colors.blue[200]!;
        _status = 'Đang chờ đánh giá';
    }
    return BlocBuilder<ReCareListBloc, ReCareListState>(
      builder: (context, state) {
        if (!widget.route) {
          _listFileImage =
              widget.reCare.contentImage!.map((e) => File(e)).toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Chi tiết mục chăm sóc"),
            centerTitle: true,
            leading: widget.fromNotification
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("/MainRecare");
                    },
                    icon: Icon(Icons.arrow_back))
                : null,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "Xóa mục chăm sóc",
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        "Bạn chắc chắn muốn xóa mục chăm sóc này?",
                        textAlign: TextAlign.center,
                      ),
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
                                  MaterialStatePropertyAll(Colors.red)),
                          onPressed: () async {
                            if (widget.reCare.contentImage!.isNotEmpty) {
                              for (var image in widget.reCare.contentImage!) {
                                File(image).delete();
                              }
                            }

                            context.read<ReCareListBloc>().add(DeleteReCare(
                                reCareId: widget.reCare.reCareId!));
                            await APIsReCare.getNumSuccess(
                                widget.userRelationship.usReId!);
                            final timeOfCare = await APIsReCare.getNumSuccess(
                                widget.userRelationship.usReId!);
                            context.read<UsReListBloc>().add(
                                UpdateTimeOfCareUsRe(
                                    usReId: widget.userRelationship.usReId!,
                                    timeOfCare: timeOfCare));
                            showSnackbar(
                              context,
                              "Đã xóa mục chăm sóc",
                              Duration(seconds: 3),
                              true,
                            );
                            Navigator.of(context)
                              ..pop()
                              ..pop(true);
                          },
                          child: Text("Xóa"),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.sp, bottom: 10.sp, left: 10.sp, right: 10.sp),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: _bgCardColor,
                          borderRadius: BorderRadius.circular(5.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ]),
                      padding: EdgeInsets.all(10.sp),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.reCare.title!,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "($_status)",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                ),
                                if (widget.reCare.isFinish != 2)
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          useSafeArea: true,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) => EvaluateReCare(
                                            onEvaluate: (isSuccess) =>
                                                _onEvaluate(isSuccess),
                                            initIsSuccess:
                                                widget.reCare.isFinish == 0
                                                    ? false
                                                    : true,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.flagCheckered,
                                        color: Colors.black,
                                        size: 20.sp,
                                      )),
                              ],
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BlocBuilder<UserListBloc, UserListState>(
                                  builder: (context, state) {
                                    if (state is UserListUploaded &&
                                        state.users.isNotEmpty) {
                                      final users = state.users;
                                      for (var user in users) {
                                        if ((user.userId!.length ==
                                                widget
                                                    .userRelationship
                                                    .myRelationShipId!
                                                    .length) &&
                                            (user.userId ==
                                                widget.userRelationship
                                                    .myRelationShipId!)) {
                                          return Text(
                                            user.userName!,
                                            style: TextStyle(fontSize: 14.sp),
                                          );
                                        }
                                      }
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                showRelationshipTypeIcon(
                                    widget.userRelationship.relationships!.first
                                        .type!,
                                    16.sp),
                                SizedBox(
                                  width: 10.sp,
                                ),
                                Text(
                                  widget.userRelationship.relationships!.first
                                      .name!,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.gripLinesVertical,
                                  size: 40.sp,
                                ),
                                SizedBox(
                                  width: 5.sp,
                                ),
                                if (checkAllDay(widget.reCare.startTime!,
                                    widget.reCare.endTime!))
                                  Row(
                                    children: [
                                      Text(
                                        "Cả ngày",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      SizedBox(
                                        width: 5.sp,
                                      ),
                                    ],
                                  ),
                                Column(
                                  children: [
                                    getRowDateTime(
                                        widget.reCare.startTime!,
                                        14.sp,
                                        14.sp,
                                        checkAllDay(widget.reCare.startTime!,
                                            widget.reCare.endTime!)),
                                    getRowDateTime(
                                        widget.reCare.endTime!,
                                        14.sp,
                                        14.sp,
                                        checkAllDay(widget.reCare.startTime!,
                                            widget.reCare.endTime!)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.reCare.isFinish != 2)
                      SizedBox(
                        height: 20.sp,
                      ),
                    if (widget.reCare.isFinish != 2)
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5.sp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ]),
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ghi chép chăm sóc',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.sp),
                                ),
                                IconButton(
                                    onPressed: _isChangeText
                                        ? _addContentText
                                        : () {
                                            setState(() {
                                              _isShowNote = true;
                                            });
                                          },
                                    icon: Icon(
                                      _isChangeText
                                          ? Icons.save
                                          : _isShowNote
                                              ? Icons.edit_document
                                              : Icons.note_add_rounded,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                            widget.reCare.contentText != '' || _isChangeText
                                ? hr
                                : SizedBox(),
                            _isShowNote
                                ? TextField(
                                    maxLines: null,
                                    textInputAction: TextInputAction.newline,
                                    maxLength: 2000,
                                    controller: _contentTextController,
                                    style: TextStyle(fontSize: 14.sp),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    autocorrect: true,
                                    enableSuggestions: true,
                                    onTap: () {
                                      setState(() {
                                        _isChangeText = true;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _isChangeText = true;
                                      });
                                    },
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      counterText: '',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12.sp,
                                      ),
                                      hintText: "Ghi chép vào đây",
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: InputBorder.none,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    if (widget.reCare.isFinish != 2)
                      SizedBox(
                        height: 20.sp,
                      ),
                    if (widget.reCare.isFinish != 2)
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5.sp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ]),
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ảnh chăm sóc',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.sp),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        useSafeArea: true,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => MenuPickImage(
                                          onPickImage: (type) =>
                                              _pickImage(type),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add_a_photo_rounded,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                            _listFileImage.isNotEmpty ? hr : SizedBox(),
                            _listFileImage.isEmpty
                                ? Column(
                                    children: [
                                      Icon(
                                        Icons.photo_size_select_actual_outlined,
                                        size: 60.sp,
                                        color: Colors.grey[300],
                                      ),
                                      Text(
                                        "Hãy lưu trữ những khoảng khắc chăm sóc",
                                        style: (TextStyle(
                                          color: Colors.grey[400],
                                        )),
                                      )
                                    ],
                                  )
                                : Container(
                                    height: _listFileImage.length > 4
                                        ? 160.sp
                                        : 80.sp,
                                    child: GridView(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2,
                                      ),
                                      children: [
                                        for (int i = 0;
                                            _listFileImage.length <= 8
                                                ? i < _listFileImage.length
                                                : i < 7;
                                            i++)
                                          InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScaleImage(
                                                    imageUrl:
                                                        _listFileImage[i].path,
                                                    onDelete: (imageUrl) =>
                                                        _removeImage(imageUrl),
                                                  ),
                                                )),
                                            child: Image.file(
                                              _listFileImage[i],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        if (_listFileImage.length > 8)
                                          InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListContentImage(
                                                    listImage: widget
                                                        .reCare.contentImage!,
                                                    onDelete: (imageUrl) =>
                                                        _removeImage(imageUrl),
                                                  ),
                                                )),
                                            child: Container(
                                              color: Colors.grey[300],
                                              alignment: Alignment.center,
                                              child: Text(
                                                '+' +
                                                    (_listFileImage.length - 7)
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: Colors.blue[800]),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

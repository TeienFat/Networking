import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/widgets/take_care_card.dart';

class TakeCareScreen extends StatefulWidget {
  const TakeCareScreen({super.key});

  @override
  State<TakeCareScreen> createState() => _TakeCareScreenState();
}

class _TakeCareScreenState extends State<TakeCareScreen> {
  int _currentButtonNum = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReCareListBloc, ReCareListState>(
      builder: (context, state) {
        if (state is ReCareListUploaded && state.reCares.isNotEmpty) {
          final reCares = state.reCares;
          reCares.sort(
            (a, b) {
              if (a.endTime!.isBefore(b.endTime!)) {
                return 1;
              }

              if (a.endTime!.isAfter(b.endTime!)) {
                return -1;
              }
              return 0;
            },
          );
          List<RelationshipCare> reCaresSort;
          switch (_currentButtonNum) {
            case 1:
              reCaresSort =
                  reCares.where((element) => element.isFinish == 1).toList();
              break;
            case 2:
              reCaresSort =
                  reCares.where((element) => element.isFinish == 0).toList();
              break;
            case 3:
              reCaresSort =
                  reCares.where((element) => element.isFinish == 2).toList();
              break;
            case 4:
              reCaresSort =
                  reCares.where((element) => element.isFinish == -1).toList();
              break;
            default:
              reCaresSort = reCares;
          }

          return Padding(
            padding: EdgeInsets.all(5.sp),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                        color: _currentButtonNum == 0 ? Colors.grey[300] : null,
                      ),
                      child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _currentButtonNum = 0;
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.list,
                            size: 28.sp,
                            color: Colors.black,
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                        color: _currentButtonNum == 1 ? Colors.grey[300] : null,
                      ),
                      child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _currentButtonNum = 1;
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.check,
                            size: 28.sp,
                            color: Colors.green,
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                        color: _currentButtonNum == 2 ? Colors.grey[300] : null,
                      ),
                      child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _currentButtonNum = 2;
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.ban,
                            size: 28.sp,
                            color: Colors.red,
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                        color: _currentButtonNum == 3 ? Colors.grey[300] : null,
                      ),
                      child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _currentButtonNum = 3;
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.running,
                            size: 28.sp,
                            color: Colors.amber[600],
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                        color: _currentButtonNum == 4 ? Colors.grey[300] : null,
                      ),
                      child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _currentButtonNum = 4;
                            });
                          },
                          icon: Icon(
                            FontAwesomeIcons.clockRotateLeft,
                            size: 28.sp,
                            color: Colors.blue,
                          )),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          FontAwesomeIcons.sliders,
                          size: 28.sp,
                          color: Colors.black,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.sp,
                ),
                Container(
                  height: ScreenUtil().screenHeight * 0.75,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          BlocBuilder<UsReListBloc, UsReListState>(
                            builder: (context, state) {
                              if (state is UsReListUploaded &&
                                  state.usRes.isNotEmpty) {
                                final usRes = state.usRes;
                                for (var us in usRes) {
                                  if (us.usReId!.length ==
                                          reCaresSort[index].usReId!.length &&
                                      us.usReId! ==
                                          reCaresSort[index].usReId!) {
                                    return ReCareCard(
                                      reCare: reCaresSort[index],
                                      userRelationship: us,
                                      listType: _currentButtonNum,
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
                            height: 10.sp,
                          ),
                        ],
                      );
                    },
                    itemCount: reCaresSort.length,
                  ),
                )
              ],
            ),
          );
        }
        return Center(
          child: Text("Hãy thiết lập các mục chăm sóc mới."),
        );
      },
    );
  }
}

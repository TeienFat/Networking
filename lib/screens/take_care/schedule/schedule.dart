import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/screens/take_care/new/new_relationship_care.dart';
import 'package:networking/widgets/take_care_card.dart';
import 'package:table_calendar/table_calendar.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key, required this.listEventsToday});
  final List<RelationshipCare> listEventsToday;
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late List<RelationshipCare> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay.value;
    _selectedEvents = widget.listEventsToday;
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedEvents.length);
    return BlocBuilder<ReCareListBloc, ReCareListState>(
      builder: (context, state) {
        List<RelationshipCare> reCares;
        if (state is ReCareListUploaded && state.reCares.isNotEmpty) {
          reCares = state.reCares;
        } else
          reCares = [];
        List<RelationshipCare> _getEventsForDay(DateTime day) {
          return reCares
              .where((element) => isSameDay(element.startTime!, day))
              .toList();
        }

        List<RelationshipCare> _getEventsForRange(
            DateTime start, DateTime end) {
          final days = daysInRange(start, end);

          return [
            for (final d in days) ..._getEventsForDay(d),
          ];
        }

        void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay.value = focusedDay;
              _rangeStart = null;
              _rangeEnd = null;
              _rangeSelectionMode = RangeSelectionMode.toggledOff;
            });

            _selectedEvents = _getEventsForDay(selectedDay);
          }
        }

        void _onRangeSelected(
            DateTime? start, DateTime? end, DateTime focusedDay) {
          setState(() {
            _selectedDay = null;
            _focusedDay.value = focusedDay;
            _rangeStart = start;
            _rangeEnd = end;
            _rangeSelectionMode = RangeSelectionMode.toggledOn;
          });

          if (start != null && end != null) {
            _selectedEvents = _getEventsForRange(start, end);
          } else if (start != null) {
            _selectedEvents = _getEventsForDay(start);
          } else if (end != null) {
            _selectedEvents = _getEventsForDay(end);
          }
        }

        void _reload() {
          setState(() {
            if (_rangeStart != null && _rangeEnd != null) {
              _selectedEvents = _getEventsForRange(_rangeStart!, _rangeEnd!);
            } else if (_rangeStart != null) {
              _selectedEvents = _getEventsForDay(_rangeStart!);
            } else if (_rangeEnd != null) {
              _selectedEvents = _getEventsForDay(_rangeEnd!);
            } else {
              _selectedEvents = _getEventsForDay(_selectedDay!);
            }
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Lập lịch chăm sóc'),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 0.sp),
                child: IconButton(
                    onPressed: () async {
                      DateTime initStartDay = DateTime.now();
                      DateTime initEndDay = DateTime.now();
                      if (_selectedDay != null &&
                          checkDayAfter(_selectedDay!, DateTime.now())) {
                        initStartDay = _selectedDay!;
                        initEndDay = _selectedDay!;
                      }
                      if (_rangeStart != null && _rangeEnd != null) {
                        if (checkDayAfter(_rangeStart!, DateTime.now())) {
                          initStartDay = _rangeStart!;
                          initEndDay = _rangeEnd!;
                        }
                        if (!checkDayAfter(_rangeStart!, DateTime.now()) &&
                            checkDayAfter(_rangeEnd!, DateTime.now())) {
                          initEndDay = _rangeEnd!;
                        }
                      }
                      if (_rangeStart != null && _rangeEnd == null) {
                        if (checkDayAfter(_rangeStart!, DateTime.now())) {
                          initStartDay = _rangeStart!;
                          initEndDay = _rangeStart!;
                        }
                      }

                      await Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => NewRelationshipCare(
                            initStartDay: initStartDay, initEndDay: initEndDay),
                      ))
                          .then((value) {
                        if (value != null && value) {
                          _reload();
                        }
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      size: 40.sp,
                      color: Colors.orange[600],
                    )),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              children: [
                IconButton(onPressed: _reload, icon: Icon(Icons.cabin)),
                Container(
                  padding: EdgeInsets.only(bottom: 5.sp, right: 5.sp),
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
                  child: TableCalendar<RelationshipCare>(
                    firstDay: DateTime(1900, 01, 01),
                    lastDay: DateTime(2124, 12, 31),
                    focusedDay: _focusedDay.value,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: _onDaySelected,
                    onRangeSelected: _onRangeSelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay.value = focusedDay;
                    },
                    availableCalendarFormats: {
                      CalendarFormat.month: 'Tháng',
                      CalendarFormat.twoWeeks: '2 tuần',
                      CalendarFormat.week: 'Tuần'
                    },
                    rowHeight: 50.sp,
                    daysOfWeekHeight: 50.sp,
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                        weekdayStyle: TextStyle(
                          fontSize: 16.0,
                        )),
                    weekendDays: [DateTime.sunday],
                    calendarBuilders:
                        CalendarBuilders(dowBuilder: (context, day) {
                      if (day.weekday == DateTime.sunday) {
                        return Center(
                          child: Text(
                            MyDateUtil.getFormattedWeekday2(day),
                            style:
                                TextStyle(color: Colors.red, fontSize: 14.sp),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(MyDateUtil.getFormattedWeekday2(day),
                              style: TextStyle(fontSize: 14.sp)),
                        );
                      }
                    }, headerTitleBuilder: (context, day) {
                      return Row(
                        children: [
                          Text(
                            MyDateUtil.getFormattedMonth(day) +
                                ' ' +
                                day.year.toString(),
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(
                                  () => _focusedDay.value = DateTime.now());
                            },
                            icon: Icon(
                              Icons.calendar_today,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      );
                    }, markerBuilder: (context, day, events) {
                      if (events.length > 0) {
                        return Positioned.fill(
                            bottom: -5.sp,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: EdgeInsets.all(5.sp),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber,
                                ),
                                child: Text(events.length.toString()),
                              ),
                            ));
                      }
                      return null;
                    }),
                    calendarStyle: CalendarStyle(
                        outsideDaysVisible: true,
                        weekendTextStyle:
                            TextStyle(fontSize: 16.0, color: Colors.red),
                        defaultTextStyle: TextStyle(fontSize: 14.sp),
                        defaultDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp)),
                        todayTextStyle: TextStyle(
                            color: const Color(0xFFFAFAFA),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                        todayDecoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp)),
                        selectedDecoration: BoxDecoration(
                            color: Colors.greenAccent[700],
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp)),
                        selectedTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                        outsideDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp)),
                        rangeStartDecoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp)),
                        rangeStartTextStyle: TextStyle(
                            color: const Color(0xFFFAFAFA),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                        rangeEndTextStyle: TextStyle(
                            color: const Color(0xFFFAFAFA),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                        rangeEndDecoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp)),
                        withinRangeDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp)),
                        weekendDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp)),
                        holidayDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.sp),
                            border: Border.all(color: Colors.redAccent)),
                        holidayTextStyle: TextStyle(fontSize: 16.0)),
                    holidayPredicate: (day) {
                      if (day.month == 1 && day.day == 1) return true;
                      if (day.month == 2 && day.day == 14) return true;
                      if (day.month == 2 && day.day == 3) return true;
                      if (day.month == 3 && day.day == 8) return true;
                      if (day.month == 3 && day.day == 20) return true;
                      if (day.month == 3 && day.day == 26) return true;
                      if (day.month == 4 && day.day == 30) return true;
                      if (day.month == 5 && day.day == 1) return true;
                      if (day.month == 5 && day.day == 19) return true;
                      if (day.month == 6 && day.day == 1) return true;
                      if (day.month == 6 && day.day == 28) return true;
                      if (day.month == 7 && day.day == 27) return true;
                      if (day.month == 9 && day.day == 2) return true;
                      if (day.month == 10 && day.day == 20) return true;
                      if (day.month == 11 && day.day == 20) return true;
                      if (day.month == 12 && day.day == 22) return true;
                      if (day.month == 12 && day.day == 25) return true;
                      return false;
                    },
                  ),
                ),
                SizedBox(height: 10.sp),
                Expanded(
                  child: ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (isSameDay(_selectedEvents[index].startTime!,
                              DateTime.now()))
                            Padding(
                              padding: EdgeInsets.only(bottom: 5.sp),
                              child: Row(children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 30.sp,
                                ),
                                SizedBox(
                                  width: 5.sp,
                                ),
                                Text(
                                  "Hôm nay",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                            ),
                          BlocBuilder<UsReListBloc, UsReListState>(
                            builder: (context, state) {
                              if (state is UsReListUploaded &&
                                  state.usRes.isNotEmpty) {
                                final usRes = state.usRes;
                                for (var us in usRes) {
                                  if (us.usReId!.length ==
                                          _selectedEvents[index]
                                              .usReId!
                                              .length &&
                                      us.usReId! ==
                                          _selectedEvents[index].usReId!) {
                                    return ReCareCard.schedule(
                                      reCare: _selectedEvents[index],
                                      userRelationship: us,
                                      listType: 0,
                                      load: _reload,
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
                            height:
                                _selectedEvents[index] == _selectedEvents.last
                                    ? 70.sp
                                    : 10.sp,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

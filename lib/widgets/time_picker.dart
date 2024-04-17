import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TimePickerIcon extends StatefulWidget {
  const TimePickerIcon(
      {super.key,
      required this.onPickTime,
      required this.selectedTime,
      required this.helpText,
      required this.disabled});
  final TimeOfDay selectedTime;
  final Function(TimeOfDay timePick) onPickTime;
  final String helpText;
  final bool disabled;
  @override
  State<TimePickerIcon> createState() => _TimePickerIconState();
}

class _TimePickerIconState extends State<TimePickerIcon> {
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      cancelText: "Đóng",
      helpText: widget.helpText,
      hourLabelText: "Giờ",
      minuteLabelText: "Phút",
      errorInvalidText: "Giờ không hợp lệ",
      initialTime: widget.selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    if (time != null && time != widget.selectedTime) {
      widget.onPickTime(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        highlightColor: widget.disabled ? Colors.transparent : null,
        onPressed: () {
          widget.disabled ? null : _selectTime(context);
        },
        icon: Icon(
          Icons.access_time_filled_outlined,
          color: widget.disabled ? Colors.grey : Colors.black,
        ));
  }
}

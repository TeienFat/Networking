import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerIcon extends StatefulWidget {
  const DatePickerIcon(
      {super.key,
      required this.onPickDate,
      required this.selectedDate,
      required this.firstDate,
      required this.lastDate,
      required this.fieldText,
      required this.helpText});
  final DateTime selectedDate;
  final Function(DateTime datePick) onPickDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String helpText;
  final String fieldText;
  @override
  State<DatePickerIcon> createState() => _DatePickerIconState();
}

class _DatePickerIconState extends State<DatePickerIcon> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      helpText: widget.helpText,
      cancelText: 'Đóng',
      errorFormatText: 'Nhập ngày hợp lệ (Tháng/Ngày/Năm)',
      errorInvalidText: 'Nhập ngày trong phạm vi hợp lệ',
      fieldLabelText: widget.fieldText,
      fieldHintText: 'Tháng/Ngày/Năm',
    );

    if (picked != null && picked != widget.selectedDate) {
      widget.onPickDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          _selectDate(context);
        },
        icon: Icon(
          Icons.calendar_month_outlined,
          size: 25.sp,
        ));
  }
}

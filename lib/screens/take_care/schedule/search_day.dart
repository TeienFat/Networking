import 'package:flutter/material.dart';

class SearchDay extends StatelessWidget {
  const SearchDay({super.key, required this.onSearch});
  final Function(DateTime dayReturn) onSearch;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _enteredDay = '';
    return IconButton(
      onPressed: () {
        final now = DateTime.now();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              "Tìm ngày",
              textAlign: TextAlign.center,
            ),
            content: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: now.day.toString() +
                      '/' +
                      now.month.toString() +
                      '/' +
                      now.year.toString(),
                  decoration: InputDecoration(
                      labelText: "Nhập ngày cần tìm", hintText: "dd/mm/yyyy"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Hãy nhập ngày muốn tìm kiếm";
                    }
                    if (value.length < 9 || value.length > 10) {
                      return 'Hãy nhập đúng: dd/MM/yyyy';
                    }

                    // Tách ngày, tháng, năm
                    var parts = value.split('/');
                    if (parts.length != 3) {
                      return 'Hãy nhập đúng: dd/MM/yyyy';
                    }

                    // Ép kiểu và kiểm tra giá trị
                    try {
                      var day = int.parse(parts[0]);
                      var month = int.parse(parts[1]);
                      var year = int.parse(parts[2]);

                      if (day < 1 ||
                          day > 31 ||
                          month < 1 ||
                          month > 12 ||
                          year < 1900) {
                        return 'Hãy nhập đúng: dd/MM/yyyy';
                      }
                    } catch (e) {
                      return 'Hãy nhập đúng: dd/MM/yyyy';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    _enteredDay = newValue!;
                  },
                )),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    final getDay = _enteredDay.split('/');
                    final searchDay = DateTime(int.parse(getDay[2]),
                        int.parse(getDay[1]), int.parse(getDay[0]));
                    onSearch(searchDay);
                    Navigator.pop(context);
                  }
                },
                child: Icon(Icons.search),
              ),
            ],
          ),
        );
      },
      icon: Icon(
        Icons.search,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}

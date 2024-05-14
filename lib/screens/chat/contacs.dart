import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/widgets/user_card.dart';
import 'package:tiengviet/tiengviet.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool isSearching = false;
  List<Users> _list = [];
  List<Users> _searchList = [];
  var currentUserId;

  int getIndexUser() {
    int index = 0;
    for (Users user in _list) {
      if (user.userId == currentUserId) {
        index = _list.indexOf(user);
        break;
      }
    }
    return index;
  }

  void _runFilter(String _enteredKeyword) {
    _searchList.clear();
    for (var user in _list) {
      if (TiengViet.parse(user.userName!)
          .toLowerCase()
          .contains(TiengViet.parse(_enteredKeyword).toLowerCase())) {
        _searchList.add(user);
      }
    }
    setState(() {
      isSearching = true;
      _searchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    APIsAuth.getCurrentUserId().then((value) => currentUserId = value);
    return Scaffold(
      appBar: AppBar(
        title: Text('Người dùng'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            children: [
              searchBar(_runFilter, ScreenUtil().screenWidth),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: APIsChat.getAllUser(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        heightFactor: 10,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!userSnapshot.hasData ||
                        userSnapshot.data!.docs.isEmpty) {
                      return const Center(
                        heightFactor: 10,
                        child: Text(
                          'Không tìm thấy người dùng',
                        ),
                      );
                    }
                    if (userSnapshot.hasError) {
                      return const Center(
                        heightFactor: 10,
                        child: Text(
                          'Có gì đó sai sai...',
                        ),
                      );
                    }
                    final data = userSnapshot.data!.docs;
                    _list = data.map((e) => Users.fromMap(e.data())).toList();
                    List<String> blockUsers = _list[getIndexUser()].blockUsers!;
                    _list.removeWhere((user) => user.userId == currentUserId);
                    _list.removeWhere(
                        (user) => blockUsers.contains(user.userId));
                    _list.sort((a, b) => a.userName!.compareTo(b.userName!));
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: isSearching
                            ? (_searchList.isEmpty ? 1 : _searchList.length)
                            : _list.length,
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: [
                              isSearching
                                  ? (_searchList.isEmpty
                                      ? Text('Không tìm thấy người dùng')
                                      : UserCard.contact(
                                          user: _searchList[index]))
                                  : UserCard.contact(user: _list[index])
                            ],
                          );
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/relationships/edit/list_reltionship_edit.dart';
import 'package:networking/screens/relationships/new/new_relationship.dart';
import 'package:networking/widgets/contacts_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class ImportContacts extends StatefulWidget {
  const ImportContacts({super.key});

  @override
  State<ImportContacts> createState() => _ImportContactsState();
}

class _ImportContactsState extends State<ImportContacts> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  bool a = true;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  void _onAddContact(Contact contact) async {
    String imageUrl = '';
    final userId = _uuid.v4();
    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
    final email = contact.emails.isNotEmpty ? contact.emails.first.address : '';
    Map<String, dynamic> otherInfo = contact.organizations.isNotEmpty
        ? {"Công ty": contact.organizations.first.company}
        : {};
    if (contact.photo != null) {
      final String path = (await getApplicationDocumentsDirectory()).path;
      File convertedImg = await File('$path/$userId.jpg').create();
      convertedImg.writeAsBytesSync(contact.photo!);
      imageUrl = convertedImg.path;
    }

    Users user = Users(
        userId: userId,
        userName: contact.displayName,
        email: email,
        imageUrl: imageUrl,
        gender: false,
        birthday: DateTime(2000, 01, 01),
        hobby: '',
        phone: phone,
        facebook: {'': ''},
        zalo: {'': ''},
        skype: {'': ''},
        address: [],
        otherInfo: otherInfo,
        notification: true,
        createdAt: null,
        updateAt: null,
        deleteAt: null,
        isShare: false,
        isOnline: false,
        blockUsers: [],
        token: '');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewRelationship.fromImport(
                  user: user,
                  relationships: [],
                )));

    setState(() {
      _contacts!.removeWhere(
        (element) => element.id == contact.id,
      );
    });
  }

  void _onUpdateContact(Contact contact) async {
    String imageUrl = '';
    final userId = _uuid.v4();
    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
    final email = contact.emails.isNotEmpty ? contact.emails.first.address : '';
    Map<String, dynamic> otherInfo = contact.organizations.isNotEmpty
        ? {"Công ty": contact.organizations.first.company}
        : {};
    if (contact.photo != null) {
      final String path = (await getApplicationDocumentsDirectory()).path;
      File convertedImg = await File('$path/$userId.jpg').create();
      convertedImg.writeAsBytesSync(contact.photo!);
      imageUrl = convertedImg.path;
    }
    Users newUser = Users(
        userId: userId,
        userName: contact.displayName,
        email: email,
        imageUrl: imageUrl,
        gender: false,
        birthday: null,
        hobby: '',
        phone: phone,
        facebook: {'': ''},
        zalo: {'': ''},
        skype: {'': ''},
        address: [],
        otherInfo: otherInfo,
        notification: true,
        createdAt: null,
        updateAt: null,
        deleteAt: null,
        isShare: false,
        isOnline: false,
        blockUsers: [],
        token: '');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListEditRelationship.fromPhonebook(
              newUser: newUser, newRelationships: []),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liên hệ từ Danh bạ"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
                top: 10.sp, bottom: 10.sp, left: 5.sp, right: 5.sp),
            child: _body()),
      ),
    );
  }

  Widget _body() {
    if (_permissionDenied)
      return Center(
          child: Text(
        'Chưa được cấp quyền truy cập danh bạ',
        style: TextStyle(fontSize: 16.sp),
      ));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, i) => Column(
        children: [
          ContactCard(_contacts![i].id, (contact) => _onAddContact(contact),
              (contact) => _onUpdateContact(contact)),
          SizedBox(height: 10.sp),
        ],
      ),
    );
  }
}

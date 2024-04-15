import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactCard extends StatelessWidget {
  ContactCard(this.contactId, this.onAddContact, this.onUpdateContact);
  final String contactId;
  final Function(Contact contact) onAddContact;
  final Function(Contact contact) onUpdateContact;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FlutterContacts.getContact(contactId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Column(
            children: [
              Text("Liên hệ không tồn tại"),
            ],
          ));
        }
        if (snapshot.hasError) {
          return Center(child: Text("Có gì đó sai sai..."));
        }
        final contact = snapshot.data!;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5.sp),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                ),
              ]),
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 5.sp),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[100],
                backgroundImage: contact.photo != null
                    ? MemoryImage(contact.photo!) as ImageProvider
                    : AssetImage('assets/images/user.png'),
                radius: 30.sp,
              ),
              SizedBox(
                width: 10.sp,
              ),
              Container(
                width: ScreenUtil().screenWidth * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Họ tên: ${contact.displayName}',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 2.sp,
                    ),
                    Text(
                      'Số điện thoại: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(Trống)'}',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 2.sp,
                    ),
                    Text(
                      'Email: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(Trống)'}',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 2.sp,
                    ),
                    Text(
                      'Công ty: ${contact.organizations.isNotEmpty ? contact.organizations.first.company : '(Trống)'}',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 2.sp,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      onAddContact(contact);
                    },
                    icon: Icon(
                      Icons.person_add_alt_1,
                      size: 30.sp,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onUpdateContact(contact);
                    },
                    icon: Icon(
                      FontAwesomeIcons.userEdit,
                      size: 23.sp,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

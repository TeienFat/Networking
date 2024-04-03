import 'package:flutter/material.dart';
import 'package:networking/apis/apis_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            APIsAuth.logout();
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/Auth", (route) => false); // FirebaseAuth.instance.signOut();
            // APIs.updateStatus(false);
          },
          icon: Icon(Icons.logout_rounded),
        ),
        Text("ProfileScreen"),
      ],
    );
  }
}

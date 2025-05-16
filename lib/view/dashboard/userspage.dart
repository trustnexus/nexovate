import 'package:flutter/material.dart';
import 'package:admin_demo/utils/textstyles.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}



class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
        Center(
          child: Column(
            children: [
              //CONTAINER FOR SEARCHING USER
              Container(
                margin: EdgeInsets.all(8),
                child: Text("Search User", style: whiteHeading1)
              ),
            ],
          )
        )
    );
  }
}

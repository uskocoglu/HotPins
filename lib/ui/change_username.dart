
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/classes/notif_card.dart';
import 'package:hotpins/model/notif.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/ui/explore_screen.dart';
import 'package:hotpins/ui/feedPage.dart';

import '../model/Posts.dart';
import '../util/styles.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();

  static const String routeName = "/changeUsername";
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final _formKey = GlobalKey<FormState>();
  String usernameDone = "";
  List<String> usernameList = [];
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  
  Future<void> changeUsername(String username) async{
    //DocumentSnapshot snapshot = await userCollection.doc(user.uid).get();
    QuerySnapshot querySnapshot = await userCollection.get();
    print(username);
    querySnapshot.docs.map((doc) => doc.get('username')).forEach((element) {
      print(element);
      usernameList.add(element);
    });
    if(usernameList.contains(username)){
      _showDialog("Invalid username", "This username is already taken!");
    }
    else{
      userCollection.doc(user.uid).update({
        "username": username,
      });
      Navigator.pushNamedAndRemoveUntil(context, Profile.routeName, (route) => false);
    }

  }
  Future<void> _showDialog(String title, String message) async {
    bool isAndroid = Platform.isAndroid;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if(isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, ProfileEdit.routeName, (route) => false);
                  },
                )
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text(title, style: welcomeButtonTextStyle),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message, style: welcomeButtonTextStyle),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, ProfileEdit.routeName, (route) => false);
                  },
                )
              ],
            );
          }

        });
  }
  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Change Username", "change_username.dart");
    return Scaffold(
      appBar: welcomeBar("Change Username"),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SingleChildScrollView(),
            SizedBox(height: SizeConfig.screenHeight*0.3),
            Container(
                height: SizeConfig.screenHeight/8,
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5,),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: AppColors.inputColor,
                    padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal),
                    child: TextFormField(
                      maxLines: 3,
                      cursorColor: AppColors.textColor,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.comment,
                          color: AppColors.textColor,
                        ),
                        hintText: "Username",
                        hintStyle: TextStyle(
                          height: 2.4,
                        ),
                        border: InputBorder.none,

                      ),


                      onSaved: (value) {
                        usernameDone = value ?? '';

                      },
                    ),
                  ),
                )
            ),
            SizedBox(height: 0,),
            Container(
              height: SizeConfig.screenHeight/15,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10,vertical: 20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: FlatButton(
                    color: AppColors.buttonColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(usernameDone);
                        _formKey.currentState!.save();
                        changeUsername(usernameDone);
                      }


                    },
                    child: Text("Submit",
                      style: welcomeButtonTextStyle,),
                  )


              ),
            ),



          ],
        ),
      ),

    );
  }
}

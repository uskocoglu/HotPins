import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/ui/profile.dart';


import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dialog.dart';
import 'package:hotpins/util/appBar.dart';

import '../model/Posts.dart';
import '../model/user.dart';
import 'FeedPage.dart';
import 'change_bio.dart';
import 'change_username.dart';
import 'explore_screen.dart';



class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();

  static const String routeName = "/profileEdit";
}

class _ProfileEditState extends State<ProfileEdit> {



  bool value = false;
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');


  Future<void> changePrivacy(bool value) async{
    userCollection.doc(user.uid).update({
      'privateAccount': value,
    });
  }
  Future<void> checkPrivacy() async{
    DocumentSnapshot snapshot = await userCollection.doc(user.uid).get();
    value = snapshot.get('privateAccount');
    print(value);

    setState((){});
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
                    Navigator.pushNamedAndRemoveUntil(context, Profile.routeName, (route) => false);
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
                    Navigator.pushNamedAndRemoveUntil(context, FeedPage.routeName, (route) => false);
                  },
                )
              ],
            );
          }

        });
  }


  @override
  void initState() {
    super.initState();
    //scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    //getData();
    checkPrivacy();

  }
  File? image;
  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemporary = File(image.path);
      setState((){this.image = imageTemporary;});

    }on PlatformException catch(e){
      print('Failed to pick image $e');
    }


  }

  Future uploadImageToFirebase(BuildContext context) async {

    String fileName = image!.path.split('/').last;
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('pictures/$fileName');
    try {
      await firebaseStorageRef.putFile(File(image!.path));
      print("Upload complete");
    } on FirebaseException catch(e) {
      print('ERROR: ${e.code} - ${e.message}');
    } catch (e) {
      print(e.toString());
    }


    try{
      final ref = FirebaseStorage.instance.ref().child('pictures/$fileName');
      var url = await ref.getDownloadURL();
      userCollection.doc(user.uid).update({
        'profilepic': url,
      });


      /*await FirebaseFirestore.instance.collection('Posts').add({
        'category': topic,
        'title': title,
        'caption': caption,
        'dislikes': 0,
        'likes': 0,
        'location': location,
        'picture':'pictures/$fileName',
        'time': formattedDate,
        'userid': currentUser.userId,
      });*/

      _showDialog("Success","Your profile picture is changed successfully");
    }
    on FirebaseException catch (e){
      print('ERROR: ${e.code} - ${e.message}');
      //switch(e.code){}

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    void onTap(index) {
      setState(() {
        selectedIndex = index;
        if(index == 0)
        {
          Navigator.pushNamedAndRemoveUntil(context, FeedPage.routeName, (route) => false);
        }
        else if(index == 1)
        {
          Navigator.pushNamedAndRemoveUntil(context, ExploreScreen.routeName, (route) => false);
        }
        else if(index == 2)
        {
          Navigator.pushNamedAndRemoveUntil(context, ProfileEdit.routeName, (route) => false);
        }
        else if(index == 3)
        {

        }
        else if(index == 4)
        {
          Navigator.pushNamedAndRemoveUntil(context, Profile.routeName, (route) => false);
        }
      });
    }
    SizeConfig().init(context);
    setCurrentScreen(analytics, "Profile Edit Page", "profile_edit.dart") ;
    return Scaffold(
      appBar: welcomeBar("Settings"),

      body: SafeArea(
        maintainBottomViewPadding: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
            height: SizeConfig.blockSizeVertical*7,
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: FlatButton(
            color: AppColors.buttonColor,
            onPressed: () async{
                await pickImage();
                if(image != null){
                  uploadImageToFirebase(context);
                }
            },
            child: Text(
              "Change Profile Picture",
              style: welcomeButtonTextStyle,
            ),
            ),
            ),
            ),
            Container(
            height: SizeConfig.blockSizeVertical*7,
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: FlatButton(
            color: AppColors.buttonColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeBio()));
            },
              child: Text(
                "Change Bio",
                style: welcomeButtonTextStyle,
              ),
            ),
            ),
            ),

            Container(
              height: SizeConfig.blockSizeVertical*7,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: FlatButton(
                  color: AppColors.buttonColor,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeUsername()));
                  },
                  child: Text(
                    "Change Username",
                    style: welcomeButtonTextStyle,
                  ),
                ),
              ),
            ),
            Container(
              height: SizeConfig.blockSizeVertical*7,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Container(
                  color: AppColors.buttonColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          "Private",
                          style: welcomeButtonTextStyle,
                        ),
                      ),
                      Switch(
                          value: value,
                          onChanged: (check){
                            setState((){
                              value = check;
                              print(value);
                              changePrivacy(value);
                      });
                      },
                      activeColor: Colors.black)
                    ],
                  ),
                )
            ),
            ),
            Container(
              height: SizeConfig.blockSizeVertical*7,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: FlatButton(
                  color: AppColors.buttonColor,
                  onPressed: () {
                    showInfoDialog("Delete Account", "Are you sure you want to delete the account?", context);
                  },
                  child: Text(
                    "Delete Account",
                    style: welcomeButtonTextStyle,
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.mainColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',


          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop),
            label: 'Map',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Camera',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',


          ),
        ],
        onTap: onTap,
      )



    );
  }
}

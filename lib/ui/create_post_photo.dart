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
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:intl/intl.dart';
import '../model/Posts.dart';
import '../model/user.dart';
import '../util/colors.dart';
import '../util/dimen.dart';
import '../util/styles.dart';
import 'FeedPage.dart';
import 'explore_screen.dart';
import 'notifications.dart';

class CreatePostPhoto extends StatefulWidget {
  const CreatePostPhoto({Key? key}) : super(key: key);
  static const String routeName = "/createPostPhoto";
  @override
  State<CreatePostPhoto> createState() => _CreatePostPhotoState();

}

class _CreatePostPhotoState extends State<CreatePostPhoto> {
  List<String> userPosts = [];
  var currentUser = OurUser(followRequests: [], follower: [], following: [], posts: [], userId: "", username: "", email: "", private: false, fullName: "", bio: "", bookmark: [], notifications: [], method: "", profilePic: "");
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  Future<void> getData() async {
    // Get docs from collection reference
    DocumentSnapshot snapshot = await userCollection.doc(user.uid).get();
    // Get data from docs and convert map to List
    currentUser.userId = snapshot.get('id');
    currentUser.fullName = snapshot.get('fullname');
    currentUser.email = snapshot.get('email');
    currentUser.method = snapshot.get('method');
    currentUser.follower = List<String>.from(snapshot.get('Followers'));
    currentUser.following = List<String>.from(snapshot.get('Following'));
    currentUser.posts = List<String>.from(snapshot.get('Posts'));
    currentUser.bio = snapshot.get('bio');
    currentUser.bookmark = List<String>.from(snapshot.get('bookmark'));
    currentUser.notifications = List<String>.from(snapshot.get('Followers'));
    currentUser.private = snapshot.get('privateAccount');
    currentUser.profilePic = snapshot.get('profilepic');
    currentUser.username = snapshot.get('username');
    setState((){});

    print(currentUser.username);
  }
  @override
  void initState() {
    super.initState();
    //scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    getData();

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
  File? image;
  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemporary = File(image.path);
      setState((){this.image = imageTemporary;
      isImageSelected = true;});
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
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk:mm:ss').format(now);
      DocumentReference ref = FirebaseFirestore.instance.collection('Posts').doc();
      await ref.set({
        'category': topic,
        'title': title,
        'caption': caption,
        'dislikes': [],
        'likes': [],
        'comments': [],
        'location': location,
        'picture':'pictures/$fileName',
        'time': formattedDate,
        'userid': currentUser.userId,
        'post_id': ref.id,
      });
      DocumentSnapshot snapshot2 = await userCollection.doc(user.uid).get();
      userPosts = List<String>.from(snapshot2.get('Posts'));
      userPosts.add(ref.id);
      userCollection.doc(currentUser.userId).update({
        'Posts': userPosts,
      });

      _showDialog("Success","Your post is created successfully");
    }
    on FirebaseException catch (e){
      print('ERROR: ${e.code} - ${e.message}');
      //switch(e.code){}

    } catch (e) {
      print(e.toString());
    }
  }




  int selectedIndex = 0;
  bool isImageSelected = false;

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
  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Create post photo", "create_post_photo.dart");
    return Scaffold(appBar: pageBar(context),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              image != null ? Image.file(image!, width: 400, height: 400, fit: BoxFit.cover,) : Container(width:400,child: Card(), height: 400,),



              SizedBox(height: SizeConfig.blockSizeHorizontal*6),

              Container(
                height: SizeConfig.screenHeight/15,
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: FlatButton(
                      color: AppColors.buttonColor,
                      onPressed: () async{
                        await pickImage();
                        /*if(_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              //database check
                            }*/

                      },
                      child: Text(isImageSelected ==false ? "Select Image": "Change Image",
                        style: welcomeButtonTextStyle,),
                    )


                ),
              ),

              SizedBox(height: SizeConfig.blockSizeHorizontal*3),

              isImageSelected==true? Container(
                height: SizeConfig.screenHeight/15,
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: FlatButton(
                      color: Colors.green,
                      onPressed: () async{
                        uploadImageToFirebase(context);

                      },
                      child: Text("Create Post",
                        style: welcomeButtonTextStyle,),
                    )


                ),
              ) : Container(),


              SizedBox(height: SizeConfig.screenHeight/20),
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
        ));
  }
}
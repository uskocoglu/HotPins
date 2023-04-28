import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/ui/choose_location.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/util/appBar.dart';

import '../model/Posts.dart';
import '../model/location.dart';
import '../util/colors.dart';
import '../util/dimen.dart';
import '../util/styles.dart';
import 'FeedPage.dart';
import 'create_post_photo.dart';
import 'explore_screen.dart';
import 'notifications.dart';

class EditPost extends StatefulWidget {
  const EditPost({Key? key, required this.data }) : super(key: key);
  static const String routeName = "/editPost";
  final Post data;
  @override
  State<EditPost> createState() => _EditPostState();

}

class _EditPostState extends State<EditPost> {
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
  late FixedExtentScrollController scrollController;
  final items = [
    "",

  ];
  Future getTopics(BuildContext context) async {

    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection("Topics").get().then((event) {

        for (var doc in event.docs) {
          items.add(doc['name']);
          print(items);
        }
        setState((){});

      });

    }
    on FirebaseException catch (e){
      print('ERROR: ${e.code} - ${e.message}');
      //switch(e.code){}

    } catch (e) {
      print(e.toString());
    }
  }
 String currentPostTitle = "";
  Future getTitle(BuildContext context) async {

    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final docRef = db.collection("Posts").doc(widget.data.postId);
      await docRef.get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          currentPostTitle = data['title'];
          setState((){});
        },
        onError: (e) => print("Error getting title: $e"),
      );

    }
    on FirebaseException catch (e){
      print('ERROR: ${e.code} - ${e.message}');
      //switch(e.code){}

    } catch (e) {
      print(e.toString());
    }
  }

  String currentPostTopic = "";
  Future getTopic(BuildContext context) async {

    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final docRef = db.collection("Posts").doc(widget.data.postId);
      await docRef.get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          currentPostTopic = data['category'];
          setState((){});
        },
        onError: (e) => print("Error getting title: $e"),
      );

    }
    on FirebaseException catch (e){
      print('ERROR: ${e.code} - ${e.message}');
      //switch(e.code){}

    } catch (e) {
      print(e.toString());
    }
  }

  String currentPostLocation = "";
  Future getLocation(BuildContext context) async {

    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final docRef = db.collection("Posts").doc(widget.data.postId);
      await docRef.get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          currentPostLocation = data['location'];
          LocationName = currentPostLocation;
          setState((){});
        },
        onError: (e) => print("Error getting title: $e"),
      );

    }
    on FirebaseException catch (e){
      print('ERROR: ${e.code} - ${e.message}');
      //switch(e.code){}

    } catch (e) {
      print(e.toString());
    }
  }

  String currentPostCaption = "";
  Future getCaption(BuildContext context) async {

    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final docRef = db.collection("Posts").doc(widget.data.postId);
      await docRef.get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          currentPostCaption = data['caption'];
          setState((){});
        },
        onError: (e) => print("Error getting title: $e"),
      );

    }
    on FirebaseException catch (e){
      print('ERROR: ${e.code} - ${e.message}');
      //switch(e.code){}

    } catch (e) {
      print(e.toString());
    }
  }



  int selectedListIndex = 0;

  Future editPost(BuildContext context) async {

    try{
      await FirebaseFirestore.instance.collection('Posts').doc(widget.data.postId).update({
        'category': items[selectedListIndex],
        'title': title2,
        'caption': caption2,
        'location': LocationName,});

      _showDialog("Success","Your post is updated successfully");
    }
    on FirebaseException catch (e){
      print('ERROR: ${e.code} - ${e.message}');
      //switch(e.code){}

    } catch (e) {
      print(e.toString());
    }
  }


  File? image;
  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemporary = File(image.path);
      setState(()=>this.image = imageTemporary);
    }on PlatformException catch(e){
      print('Failed to pick image $e');
    }


  }




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

  @override
  void initState() {
    super.initState();
    scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    getTopics(context);
    getCaption(context);
    getTitle(context);
    getLocation(context);
    getTopic(context);
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  String caption2 ="";
  String title2="";
  bool firstLoad = true;
  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Edit Post", "edit_post.dart");
    return Scaffold(appBar: pageBar(context),
        body: SingleChildScrollView(
          child: Form(key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: SizeConfig.screenHeight/20,),


                Container(
                    height: SizeConfig.screenHeight/15,
                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Container(
                          color: AppColors.inputColor,
                          padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal),
                          child: TextFormField(
                            cursorColor: AppColors.textColor,
                            decoration:  InputDecoration(
                              icon: Icon(
                                Icons.title,
                                color: AppColors.textColor,
                              ),
                              hintText: currentPostTitle,
                              border: InputBorder.none,
                            ),

                            onSaved: (value){
                              title2 = value ?? '';

                            },

                          ),
                        )
                    )
                ),


                SizedBox(height: SizeConfig.blockSizeHorizontal*4),


                Container(
                    height: SizeConfig.screenHeight/8,
                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        color: AppColors.inputColor,
                        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal),
                        child: TextFormField(
                          maxLines: 3,
                          cursorColor: AppColors.textColor,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.closed_caption,
                              color: AppColors.textColor,
                            ),
                            hintText: currentPostCaption,
                            hintStyle: TextStyle(
                              height: 2.4,
                            ),
                            border: InputBorder.none,

                          ),

                          onSaved: (value) {
                            caption2 = value ?? '';

                          },
                        ),
                      ),
                    )
                ),


                SizedBox(height: SizeConfig.blockSizeHorizontal*6),

                Center(child: firstLoad ? Text("$currentPostTopic",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)) : Text(items[selectedListIndex],style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),



                SizedBox(height: SizeConfig.blockSizeHorizontal*6),


                Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: FlatButton(
                        color: AppColors.buttonColor,
                        onPressed: () {
                          scrollController.dispose();
                          scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
                          showCupertinoModalPopup(context: context, builder: (context) => CupertinoActionSheet(actions: [buildPicker()], cancelButton: CupertinoActionSheetAction(child: Text('Cancel', style: profileNameTextStyle,),onPressed: ()=> Navigator.pop(context),),));
                          /*if(_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                //database check
                              }*/

                        },
                        child: Text("Select Topic",
                          style: welcomeButtonTextStyle,),
                      )


                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeHorizontal*6),

                Center(child: Text("${LocationName}",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),

                SizedBox(height: SizeConfig.blockSizeHorizontal*6),

                Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: FlatButton(
                        color: AppColors.buttonColor,
                        onPressed: () {
                          Navigator.pushNamed(context, CreatePostLocation.routeName).then((_) => setState(() {}));

                        },
                        child: Text("Select Location",
                          style: welcomeButtonTextStyle,),
                      )


                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal*8),

                Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: FlatButton(
                        color: Colors.green,
                        onPressed: () {
                          _formKey.currentState!.save();

                          print("$topic +++ $location +++ $title +++ $caption");

                          editPost(context);


                        },
                        child: Text("Update Post",
                          style: welcomeButtonTextStyle,),
                      )


                  ),
                ),


                SizedBox(height: SizeConfig.screenHeight/20),
              ],
            ),
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
  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostLocation()),
    );

    //below you can get your result and update the view with setState
    //changing the value if you want, i just wanted know if i have to
    //update, and if is true, reload state

    if (result) {
      setState(() {});
    }
  }
  Widget buildPicker() => SizedBox(height: 350,child: CupertinoPicker(scrollController: scrollController,looping : true, itemExtent: 64, onSelectedItemChanged: (index){ setState((){this.selectedListIndex = index; firstLoad = false;});
  final item = items[index];
  print('Selected Item: $item');

  }, children: items.map((item) =>  Center(child: Text(item, style: TextStyle(fontSize: 32),),)).toList()));
}
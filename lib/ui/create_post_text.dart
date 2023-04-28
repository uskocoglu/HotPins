
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'bottom_map.dart';
import 'create_post_photo.dart';
import 'explore_screen.dart';
import 'notifications.dart';

class CreatePostText extends StatefulWidget {
  const CreatePostText({Key? key, }) : super(key: key);
  static const String routeName = "/createPostText";
  @override
  State<CreatePostText> createState() => _CreatePostTextState();

}

class _CreatePostTextState extends State<CreatePostText> {
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

  int selectedListIndex = 0;



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
        Navigator.pushNamed(context, BottomMap.routeName);

      }
      else if(index == 3)
      {
        Navigator.pushNamedAndRemoveUntil(context, CreatePostText.routeName, (route) => false);
      }
      else if(index == 4)
      {
        Navigator.pushNamedAndRemoveUntil(context, Profile.routeName, (route) => false);
      }
    });
  }

  @override
  void initState(){
    super.initState();
    scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    getTopics(context);
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  String caption2 ="";
  String title2="";

  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Create post text", "create_post_text.dart");
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
                            decoration: const InputDecoration(
                              icon: Icon(
                                Icons.title,
                                color: AppColors.textColor,
                              ),
                              hintText: "Title",
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
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.closed_caption,
                              color: AppColors.textColor,
                            ),
                            hintText: "Caption",
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

                Center(child: Text(items[selectedListIndex],style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),



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
                        color: AppColors.buttonColor,
                        onPressed: () {
                          _formKey.currentState!.save();



                          location = LocationName;
                          caption = caption2;
                          topic = items[selectedListIndex];
                          title = title2;
                          print("$topic +++ $location +++ $title +++ $caption");

                          Navigator.pushNamed(context, CreatePostPhoto.routeName);

                        },
                        child: Text("Pick Picture",
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
  Widget buildPicker() => SizedBox(height: 350,child: CupertinoPicker(scrollController: scrollController,looping : true, itemExtent: 64, onSelectedItemChanged: (index){ setState(()=> this.selectedListIndex = index);
  final item = items[index];
  print('Selected Item: $item');

  }, children: items.map((item) =>  Center(child: Text(item, style: TextStyle(fontSize: 32),),)).toList()));
}









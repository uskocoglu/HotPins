import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/services/analytics.dart';

import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:hotpins/util/dimen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();

  static const String routeName = "/changePassword";
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();
  String oldPassword = "";
  String newPassword = "";



  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Change Password Page", "change_password.dart") ;
    SizeConfig().init(context);

    return Scaffold(
      appBar: welcomeBar("Settings"),
      body: SafeArea(
        child: Center(
          child:
          Form(
            key:  _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [


                Container(
                    height: SizeConfig.screenHeight/15,
                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),

                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Container(
                          color: AppColors.inputColor,
                          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
                          child: TextFormField(
                            cursorColor: AppColors.textColor,
                            decoration: const InputDecoration(
                              hintText: "Old Password",
                              border: InputBorder.none,
                            ),


                            validator: (value) {
                              if(value != null){
                                if(value.isEmpty) {
                                  return 'Cannot leave old password empty';
                                }
                              }
                            },

                            onSaved: (value){
                              oldPassword = value ?? '';
                            },
                          ),
                        )
                    )
                ),


                SizedBox(height: SizeConfig.blockSizeVertical*3),


                Container(
                    height: SizeConfig.screenHeight/15,
                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Container(
                        color: AppColors.inputColor,
                        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
                        child: TextFormField(
                          obscureText: true,
                          cursorColor: AppColors.textColor,
                          decoration: const InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,

                          ),


                          validator: (value) {
                            if(value != null){
                              if(value.isEmpty) {
                                return 'Cannot leave password empty';
                              }
                              if(value.length < 6) {
                                return 'Password too short';
                              }
                            }
                          },
                          onSaved: (value) {
                            newPassword = value ?? '';
                          },
                        ),
                      ),
                    )
                ),


                SizedBox(height: SizeConfig.blockSizeVertical*4),

                Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: FlatButton(
                        color: AppColors.buttonColor,
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            //database check
                          }

                        },
                        child: Text("Change Password",
                          style: welcomeButtonTextStyle,),
                      )


                  ),
                ),



              ],
            ),

          ),
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(

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
        //onTap: ONTAP,
      ),
    );
  }
}

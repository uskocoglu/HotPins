import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/util/styles.dart';

import '../services/authentication.dart';
import 'FeedPage.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
  static const String routeName = "/signup";
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  String name = "";
  String surname = "";
  String mail = "";
  String username = "";
  String password = "";
  List<String> usernameList = [];

  CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> checkUsername()async {
    QuerySnapshot querySnapshot = await userCollection.get();
    //print(username);
    querySnapshot.docs.map((doc) => doc.get('username')).forEach((element) {
      print(element);
      usernameList.add(element);
    });
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    //scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    checkUsername();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    setCurrentScreen(analytics, "Sign Up Page", "signup.dart") ;
    return Scaffold(
      appBar: welcomeBar("Hot Pins"),

      body: Center(
        child:
        Form(
          key:  _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*11),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      color: AppColors.inputColor,
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
                      child: TextFormField(
                        obscureText: false,
                        cursorColor: AppColors.inputColor,
                        decoration: const InputDecoration(
                          hintText: "Name",
                          border: InputBorder.none,

                        ),


                        validator: (value) {
                          if(value != null){
                            if(value.isEmpty) {
                              return 'Cannot leave name empty';
                            }

                          }
                        },
                        onSaved: (value) {
                          name = value ?? '';
                        },
                      ),
                    ),
                  )
              ),

              SizedBox(height: SizeConfig.screenHeight/25),

              Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*11),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      color: AppColors.inputColor,
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
                      child: TextFormField(
                        obscureText: false,
                        cursorColor: AppColors.textColor,
                        decoration: const InputDecoration(

                          hintText: "Surname",
                          border: InputBorder.none,

                        ),


                        validator: (value) {
                          if(value != null){
                            if(value.isEmpty) {
                              return 'Cannot leave surname empty';
                            }
                          }
                        },
                        onSaved: (value) {
                          surname = value ?? '';
                        },
                      ),
                    ),
                  )
              ),

              SizedBox(height: SizeConfig.screenHeight/25),


              Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*11),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      color: AppColors.inputColor,
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
                      child: TextFormField(
                        obscureText: false,
                        cursorColor: AppColors.textColor,
                        decoration: const InputDecoration(

                          hintText: "Email",
                          border: InputBorder.none,

                        ),


                        validator: (value) {
                          if(value != null){
                            if(value.isEmpty) {
                              return 'Cannot leave mail empty';
                            }

                          }
                        },
                        onSaved: (value) {
                          mail = value ?? '';
                        },
                      ),
                    ),
                  )
              ),

              SizedBox(height: SizeConfig.screenHeight/25,),


              Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*11),

                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Container(
                        color: AppColors.inputColor,
                        padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
                        child: TextFormField(
                          cursorColor: AppColors.textColor,
                          decoration: const InputDecoration(
                            hintText: "Username",
                            border: InputBorder.none,
                          ),


                          validator: (value) {

                            if(value != null){
                              if(value.isEmpty) {
                                return 'Cannot leave username empty';
                              }
                              else if (usernameList.contains(value)){
                                return 'This username has already taken';
                              }

                            }
                          },
                          onSaved: (value) {
                            username = value ?? '';
                          },
                        ),
                      )
                  )
              ),


             SizedBox(height: SizeConfig.screenHeight/25,),


              Container(
                  height: SizeConfig.screenHeight/15,
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*11),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      color: AppColors.inputColor,
                      padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
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
                          password = value ?? '';
                        },
                      ),
                    ),
                  )
              ),


              SizedBox(height: SizeConfig.screenHeight/25,),

              Container(
                height: SizeConfig.screenHeight/15,
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*11),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: FlatButton(
                      color: AppColors.buttonColor,
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          AuthService().signUp(name, surname, mail, username, password);
                          //database check
                          Navigator.pushNamedAndRemoveUntil(context, FeedPage.routeName, (route) => false);
                        }

                      },
                      child: Text("Sign Up",
                        style: welcomeButtonTextStyle,),
                    )


                ),
              ),


              SizedBox(height: SizeConfig.screenHeight/25,),
            ],
          ),

        ),
      ),

    );
  }
}

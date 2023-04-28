import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:hotpins/services/google_sign_in.dart';
import 'package:hotpins/ui/profile.dart';
import "package:hotpins/services/analytics.dart";

import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/ui/feedPage.dart';

import '../services/authentication.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var loading = false;

  void _logInWithFacebook() async{
    setState((){loading = true;});

    try{
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
        'imageUrl': userData['picture']['data']['url'],
        'name': userData['name'],
      });

      Navigator.pushNamedAndRemoveUntil(context, Profile.routeName, (route) => false);
    }
    on Exception catch (e){
      var title = '';
      //switch(e.code){}

    }
    finally {
      setState((){loading = false;});
    }
}


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    setCurrentScreen(analytics, "Welcome Page", "welcome.dart") ;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasData) {
            return FeedPage();
          }
          else if(snapshot.hasError) {
            return Center(child: Text('Something Went Wrong!'));
          }
          else {return SafeArea(
              maintainBottomViewPadding: false,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight/13, horizontal: SizeConfig.screenWidth/18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        height: SizeConfig.screenHeight/3,
                        margin: EdgeInsets.only(right: SizeConfig.screenWidth/6),
                        child: Image.network(
                          "http://assets.stickpng.com/images/58889201bc2fc2ef3a1860a7.png",
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight/15),
                    Container(
                      height: SizeConfig.screenHeight/15,
                      margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: FlatButton(
                          color: AppColors.buttonColor,
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            "Login",
                            style: welcomeButtonTextStyle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight/20),
                    Container(
                      height: SizeConfig.screenHeight/15,
                      margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: FlatButton(
                          color: AppColors.buttonColor,
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            "Sign Up",
                            style: welcomeButtonTextStyle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight/20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                        height: SizeConfig.screenHeight/20,
                        child: FlatButton(onPressed: () {
                          AuthService().googleSignIn();
                        },
                          child: Image.network("https://cdn-icons-png.flaticon.com/512/2991/2991148.png",fit: BoxFit.fitHeight,),
                        ),
                      ),
                        SizedBox(
                          height: SizeConfig.screenHeight/20,
                          child: FlatButton(onPressed: () {
                            _logInWithFacebook();
                          },
                              child: Image.network("https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo.png")),
                        ),],
                    ),
                  ],
                ),
              ));
        }
        }
      ),

    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotpins/services/authentication.dart';
import 'package:hotpins/services/google_sign_in.dart';
import 'package:hotpins/ui/Dm.dart';
import 'package:hotpins/ui/OnBoarding.dart';
import 'package:hotpins/ui/add_comment.dart';
import 'package:hotpins/ui/bottom_map.dart';
import 'package:hotpins/ui/change_bio.dart';
//import 'package:hotpins/ui/post_card.dart';
import 'package:hotpins/ui/change_password.dart';
import 'package:hotpins/ui/change_username.dart';
import 'package:hotpins/ui/choose_location.dart';
import 'package:hotpins/ui/create_post_photo.dart';
import 'package:hotpins/ui/create_post_text.dart';
import 'package:hotpins/ui/edit_post.dart';
import 'package:hotpins/ui/explore_screen.dart';
import 'package:hotpins/ui/feedPage.dart';
import 'package:hotpins/ui/login.dart';
import 'package:hotpins/ui/notifications.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/ui/signup.dart';
import 'package:hotpins/ui/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hotpins/ui/zoomed_pp.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(Annotation(showHome: showHome));
}

class Annotation extends StatelessWidget {
  final bool showHome;
  const Annotation({Key? key,
    required this.showHome,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider()

        ),],
      child: MaterialApp(
        routes: {
          '/welcome': (context) => const Welcome(),
          SignUp.routeName: (context) => const SignUp(),
          Login.routeName: (context) => const Login(),
          ProfileEdit.routeName: (context) => const ProfileEdit(),
          ChangePassword.routeName: (context) => const ChangePassword(),
          ExploreScreen.routeName: (context) => const ExploreScreen(),
          FeedPage.routeName: (context) => const FeedPage(),
          //PostCard.routeName: (context) => PostCard(),
          Profile.routeName: (context) => const Profile(),
          Notifications.routeName: (context) => const Notifications(),
          CreatePostText.routeName: (context) => const CreatePostText(),
          CreatePostLocation.routeName: (context) => const CreatePostLocation(),
          CreatePostPhoto.routeName: (context) => const CreatePostPhoto(),
          Dm.routeName: (context) => const Dm(),
          ChangeBio.routeName: (context) => const ChangeBio(),
          ChangeUsername.routeName: (context) => const ChangeUsername(),
          BottomMap.routeName: (context) => const BottomMap(),



        },
        home: showHome ? const Welcome() : const OnBoarding(),
      ),
    );
  }
  }







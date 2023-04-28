import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/classes/chatCard.dart';
import 'package:hotpins/model/chat.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/ui/create_post_text.dart';
import 'package:hotpins/ui/edit_post.dart';
import 'package:hotpins/ui/explore_screen.dart';
import 'package:hotpins/ui/feedPage.dart';
import 'package:hotpins/ui/message_screen.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:hotpins/util/colors.dart';



class Dm extends StatefulWidget {
  const Dm({Key? key}) : super(key: key);

  static const String routeName = "/Dm";

  @override
  State<Dm> createState() => _DmState();
}

final user = FirebaseAuth.instance.currentUser;
String? uid = user?.uid;





class _DmState extends State<Dm> {

  List <Chat> chats = [
  ];


  final CollectionReference messageCollection = FirebaseFirestore.instance.collection('Messages');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  String messager = "";
  List <String> message = [];
  List <bool> who_send = [];
  String id_doc = "";
  String last_message = "";
  bool is_user1 = true;
  String image_url = "";
  String chat_name = "";

  bool find = false;

  Future<void> getMessages() async {

   QuerySnapshot querySnapshot = await messageCollection.get();
   QuerySnapshot querySnapshot2 = await userCollection.get();
   final chat = querySnapshot.docs.forEach((element){
     if (element['user_id1'] == uid){

       find = true;
       id_doc = element['id'];
       messager = element['user_id2'];
       for (int i = 0; i < element['Messages'].length; i++){
         message.add(element['Messages'][i]);
       }
       last_message = message.last;
       for (int i = 0; i < element['user1_send'].length; i++){
         who_send.add(element['user1_send'][i]);
       }


     }
     else if (element['user_id2'] == uid){
       find = true;
       id_doc = element['id'];
       messager = element['user_id1'];
       is_user1 = false;
       for (int i = 0; i < element['Messages'].length; i++){
         message.add(element['Messages'][i]);
       }
       last_message = message.last;
       for (int i = 0; i < element['user1_send'].length; i++) {
         who_send.add(element['user1_send'][i]);
       }

     }
     if (find){

       final chat2 = querySnapshot2.docs.forEach((element2){
         if (messager == element2['id']){
           image_url = element2['profilepic'];
           chat_name = element2['fullname'];

         }
       });
       print(message);
       chats.add(Chat(name: chat_name,id: messager, messages: message, image: image_url, doc_id: id_doc, who_send: who_send, is_user1: is_user1));
       find = false;
       messager = "";
       message = [];
       who_send = [];

       id_doc = "";
       last_message = "";
       is_user1 = true;
       image_url = "";
       chat_name = "";
     }

   });

   setState( () {});
 }

  bool check = true;

  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "DM", "Dm.dart");
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
          Navigator.pushNamedAndRemoveUntil(context, EditPost.routeName, (route) => false);

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
    if (check) {
      getMessages();
      check = false;
    }


    return Scaffold(
      appBar: pageBar(context),


      body: SafeArea(
        child: ListView.builder(
          itemCount: chats.length,
            itemBuilder: (context, index) => ChatCard(
              chat: chats[index],
              press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => message_screen(data : chats[index]))),
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
      ),
    );
  }
}


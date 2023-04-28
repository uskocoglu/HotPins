import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotpins/model/chat.dart';
import 'package:hotpins/model/notif.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/services/authentication.dart';
import 'package:hotpins/ui/explore_screen.dart';
import 'package:hotpins/ui/message_screen.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/model/user.dart';
import 'package:hotpins/model/Posts.dart';
import 'package:hotpins/ui/post_card.dart';
import '../classes/post.dart';
import 'FeedPage.dart';
import 'package:hotpins/services/database.dart';

import '../util/styles.dart';
import 'add_comment.dart';
import 'edit_post.dart';

class OtherProfilePage extends StatefulWidget {
  const OtherProfilePage({this.data});

  final Map<String, dynamic>? data;

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {

  List<Post> postsList = [];
  List<String> postIDList = [];
  List<String> userPostIDList = [];
  bool follows = false;
  bool requestSent = false;
  String notifID = "";

  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference postCollection = FirebaseFirestore.instance.collection("Posts");
  final CollectionReference notifCollection = FirebaseFirestore.instance.collection("Notifications");
  Future<void> getPosts() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await postCollection.get();

    // Get data from docs and convert map to List
    //final postData = querySnapshot.docs.map((doc) => doc.data()).toList();

    //for a specific field
    final postID = querySnapshot.docs.map((doc) => doc.get('post_id')).forEach((element) {
      print(element);
      postIDList.add(element);
    });
    //print(postID);
    //postIDList.add(postID);
    for(var item in postIDList){
      DocumentSnapshot snapshot = await postCollection.doc(item).get();
      print("!!!!!!!!!!!!!!!!!!!");
      print(widget.data!['id']);
      print("!!!!!!!!!!!!!!!!!!!");
      if(snapshot.get('userid') == widget.data!['id']){
        userPostIDList.add(item);
      }
    }
    for(var item in userPostIDList){
      //print(item);

      DocumentSnapshot snapshot2 = await postCollection.doc(item).get();
      final ref = FirebaseStorage.instance.ref().child(snapshot2.get('picture'));
      var url = await ref.getDownloadURL();
      print(url);
      final currentPost =Post(
        caption: snapshot2.get('caption'),
        date: "",
        likes: List<String>.from(snapshot2.get('likes')),
        dislikes: List<String>.from(snapshot2.get('dislikes')),
        comments: List<String>.from(snapshot2.get('comments')),
        location: snapshot2.get('location'),
        picture: url,
        category: snapshot2.get('category'),
        postId: snapshot2.get('post_id'),
        userId: snapshot2.get('userid'),
        postingTime: snapshot2.get('time'),
        title: snapshot2.get('title'),
      );
      //print(currentPost.picture);
      postsList.add(currentPost);
      setState((){});

    }


  }
  var currentUser = OurUser(followRequests: [], follower: [], following: [], posts: [], userId: "", username: "", email: "", private: false, fullName: "", bio: "", bookmark: [], notifications: [], method: "", profilePic: "");
  var thisUser = OurUser(followRequests: [], follower: [], following: [], posts: [], userId: "", username: "", email: "", private: false, fullName: "", bio: "", bookmark: [], notifications: [], method: "", profilePic: "");
  Future<void> getData() async {



    // Get docs from collection reference
    DocumentSnapshot snapshot = await userCollection.doc(user.uid).get();
    // Get data from docs and convert map to List
    currentUser.followRequests = List<String>.from(snapshot.get('FollowRequests'));
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

    DocumentSnapshot snapshot2 = await userCollection.doc(widget.data!['id']).get();
    // Get data from docs and convert map to List
    thisUser.followRequests = List<String>.from(snapshot2.get('FollowRequests'));
    thisUser.userId = snapshot2.get('id');
    thisUser.fullName = snapshot2.get('fullname');
    thisUser.email = snapshot2.get('email');
    thisUser.method = snapshot2.get('method');
    thisUser.follower = List<String>.from(snapshot2.get('Followers'));
    thisUser.following = List<String>.from(snapshot2.get('Following'));
    thisUser.posts = List<String>.from(snapshot2.get('Posts'));
    thisUser.bio = snapshot2.get('bio');
    thisUser.bookmark = List<String>.from(snapshot2.get('bookmark'));
    thisUser.notifications = List<String>.from(snapshot2.get('Followers'));
    thisUser.private = snapshot2.get('privateAccount');
    thisUser.profilePic = snapshot2.get('profilepic');
    thisUser.username = snapshot2.get('username');

    print(thisUser.followRequests);

    if(thisUser.followRequests.contains(currentUser.userId)){
      requestSent = true;
    }

    QuerySnapshot querySnapshot = await notifCollection.get();

    final chat = querySnapshot.docs.forEach((element) {

      if(element['user_id'] == user.uid && element['other_user_id'] == widget.data!['id'] && element['notif_type'] == "follow_request"){
        notifID = element['id'];
      }

    });
    setState((){});

    print(currentUser.username);
  }
  Future<void> followStatus() async {
    var followerList = List<String>.from(widget.data!['Followers']);
    if(followerList.contains(user.uid)){
      follows = true;
    }
    setState((){});
  }
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  Future<void> unFollow()async{
    var followerList = List<String>.from(widget.data!['Followers']);
    followerList.remove(user.uid);
    userCollection.doc(widget.data!['id']).update({
      'Followers': followerList,
    });
    widget.data!['Followers'] = followerList;
    var followingList = List<String>.from(currentUser.following);
    followingList.remove(widget.data!['id']);

    userCollection.doc(user.uid).update({
      'Following': followingList,
    });
    follows = false;
    requestSent = false;
    if(widget.data!['privateAccount'] == true)
      postsList.clear();

    setState((){});

  }
  Future<void> Follow() async{

    DocumentReference ref2 = FirebaseFirestore.instance.collection('Notifications').doc();

    if(widget.data!['privateAccount'] == true){
      follows = false;
      requestSent = true;

      var followRequests = List<String>.from(widget.data!['FollowRequests']);
      followRequests.add(user.uid);

      userCollection.doc(widget.data!['id']).update({
        'FollowRequests': followRequests,
      });

      ref2.set({
        'id': ref2.id,
        'notif_type': 'follow_request',
        'other_user_id': widget.data!['id'],
        'post_id': "",
        'user_id': user.uid,
      });
      notifID = ref2.id;

      //notife request ekle

    }
    else{
      follows = true;
      var followerList = List<String>.from(widget.data!['Followers']);
      followerList.add(user.uid);
      userCollection.doc(widget.data!['id']).update({
        'Followers': followerList,
      });
      widget.data!['Followers'] = followerList;
      var followingList = List<String>.from(currentUser.following);
      followingList.add(widget.data!['id']);
      userCollection.doc(user.uid).update({
        'Following': followingList,
      });


    }

    setState((){});
  }
  Future<void> RequestCancel() async{
    print(notifID);

    FirebaseFirestore.instance.collection("Notifications").doc(notifID).delete();
    var followRequests = List<String>.from(widget.data!['FollowRequests']);
    followRequests.remove(user.uid);

    userCollection.doc(widget.data!['id']).update({
      'FollowRequests': followRequests,
    });

    follows = false;
    requestSent = false;

    setState((){});
  }
  List <Chat> chats = [];
  String messager = "";
  List <String> message = [];
  List <bool> who_send = [];
  String id_doc = "";
  String last_message = "";
  bool is_user1 = true;

  Future<void> Message() async{
    final CollectionReference messageCollection = FirebaseFirestore.instance.collection('Messages');

    QuerySnapshot querySnapshot = await messageCollection.get();
    DocumentReference ref = FirebaseFirestore.instance.collection('Messages').doc();

    bool control = true;

    final chat = querySnapshot.docs.forEach((element) {
      if (element['user_id1'] == user.uid && element['user_id2'] == widget.data!['id']) {
        control = false;
        id_doc = element['id'];
        messager = element['user_id2'];
        for (int i = 0; i < element['Messages'].length; i++) {
          message.add(element['Messages'][i]);
        }
        for (int i = 0; i < element['user1_send'].length; i++) {
          who_send.add(element['user1_send'][i]);
        }
        chats.add(Chat(name: widget.data!['fullname'], id: messager, messages: message, image: widget.data!['profilepic'], doc_id: id_doc, who_send: who_send, is_user1: is_user1));
      }

      else if (element['user_id2'] == user.uid && element['user_id1'] == widget.data!['id']){
        control = false;
        id_doc = element['id'];
        messager = element['user_id1'];
        is_user1 = false;
        for (int i = 0; i < element['Messages'].length; i++){
          message.add(element['Messages'][i]);
        }
        for (int i = 0; i < element['user1_send'].length; i++) {
          who_send.add(element['user1_send'][i]);
        }
        chats.add(Chat(name: widget.data!['fullname'], id: messager, messages: message, image: widget.data!['profilepic'], doc_id: id_doc, who_send: who_send, is_user1: is_user1));
      }


      
    });

    if (control == true){
      ref.set(
          {"Messages": message,
            "user1_send": who_send,
            "user_id1":user.uid,
            "user_id2":widget.data!['id'],
            "id":ref.id
          }
      );
      chats.add(Chat(name: widget.data!['fullname'], id: widget.data!['id'], messages: message, image: widget.data!['profilepic'], doc_id: ref.id, who_send: who_send, is_user1: true ));
      setState( () {});
    }
  }
  @override
  void initState() {
    super.initState();
    //scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    getData();
    getPosts();
    followStatus();
    Message();


  }



  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Other Profile", "other_profile.dart");
    int selectedIndex = 0;
    //final snapshot = FirebaseFirestore.instance.collection('customers').doc(user.uid).get();
    //OurUser? currentUser = Provider.of<OurUser?>(context);
    //print(currentUser!.method);


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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 10,
          title: Text("Hot Pins",
              style: headingTextStyle),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[AppColors.primary, AppColors.secondary]
                )
            ),
          ),

        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical*4, SizeConfig.blockSizeHorizontal*7, 0),
                          child: CircleAvatar(
                            radius: 60,
                            child: ClipOval(
                              child: Image.network(
                                widget.data!['profilepic'],
                                fit: BoxFit.fill,
                                width: SizeConfig.screenWidth/3,
                              ),
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical*4, SizeConfig.blockSizeHorizontal*5, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [

                                  Text(
                                    widget.data!['username'],
                                    style: profileNameTextStyle,
                                  ),

                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [


                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                                      child: Text(
                                          widget.data!['Posts'].length.toString(),
                                          style: profileTextStyle
                                      ),
                                    ),
                                    Text('Posts',
                                        style: profileTextStyle
                                    )
                                  ],
                                ),
                                SizedBox(width: SizeConfig.blockSizeHorizontal*5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                                      child: Text(widget.data!['Followers'].length.toString(),
                                          style: profileTextStyle),
                                    ),
                                    Text('Follower',
                                        style: profileTextStyle)
                                  ],
                                ),
                                SizedBox(width: SizeConfig.blockSizeHorizontal*5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:  [
                                    Padding(
                                      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                                      child: Text(widget.data!['Following'].length.toString(),
                                          style: profileTextStyle),
                                    ),
                                    Text('Following',
                                        style: profileTextStyle)
                                  ],
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                if(follows == true)
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                                        child: Container(
                                          height: SizeConfig.screenHeight/20,
                                          width: SizeConfig.screenWidth/2,
                                          margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical*2),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(80),
                                            child: FlatButton(
                                              color: AppColors.mainColor,
                                              onPressed: () {
                                                unFollow();
                                              },
                                              child:
                                              Text(
                                                "Following",
                                                style: loginTextStyle,

                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: SizeConfig.screenHeight/20,
                                        width: SizeConfig.screenWidth/2,
                                        margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(80),
                                          child: FlatButton(
                                            color: AppColors.mainColor,
                                            onPressed: () {

                                              Navigator.push(context, MaterialPageRoute(builder: (context) => message_screen(data : chats[0])));
                                            },
                                            child:
                                            Text(
                                              "Message",
                                              style: loginTextStyle,

                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else if (follows == false && widget.data!['privateAccount'] == true && requestSent == true)
                                  Padding(
                                    padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                                    child: Container(
                                      height: SizeConfig.screenHeight/20,
                                      width: SizeConfig.screenWidth/2,
                                      margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical*2),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(80),
                                        child: FlatButton(
                                          color: AppColors.mainColor,
                                          onPressed: () {
                                            RequestCancel();
                                          },
                                          child:
                                          Text(
                                            "Requested",
                                            style: loginTextStyle,

                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                    Padding(
                                      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                                      child: Container(
                                        height: SizeConfig.screenHeight/20,
                                        width: SizeConfig.screenWidth/2,
                                        margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical*2),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(80),
                                          child: FlatButton(
                                            color: AppColors.mainColor,
                                            onPressed: () {
                                              Follow();
                                            },
                                            child:
                                            Text(
                                              "Follow",
                                              style: loginTextStyle,

                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                              ],
                            ),

                          ],
                        ),
                      ]
                  ),
                  Column(
                      children: <Widget>[
                        if(follows == true)
                          for (int i=0; i<postsList.length; i++ )

                            card(postsList[i],
                                widget.data!['username'],
                                "",
                                postsList[i].category,
                                postsList[i].location,
                                postsList[i].caption,
                                postsList[i].picture, (){Navigator.push(context, MaterialPageRoute(builder: (context) => AddComment(data: postsList[i],)));},
                                context, (){setState((){});}, thisUser, (){})
                        else if (widget.data!['privateAccount'] == false && follows == false)
                          for (int i=0; i<postsList.length; i++ )

                            card(postsList[i],
                                widget.data!['username'],
                                "",
                                postsList[i].postingTime,
                                postsList[i].location,
                                postsList[i].caption,
                                postsList[i].picture, (){Navigator.push(context, MaterialPageRoute(builder: (context) => AddComment(data: postsList[i],)));},
                                context, (){setState((){});}, thisUser, (){Navigator.push(context, MaterialPageRoute(builder: (context) => EditPost(data: postsList[i],)));})

                      ]
                  ),
                ],
              ),
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
        )

    );
  }
}

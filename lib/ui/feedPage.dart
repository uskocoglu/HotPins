import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotpins/model/Posts.dart';
import 'package:hotpins/ui/add_comment.dart';
import 'package:hotpins/ui/create_post_text.dart';
import 'package:hotpins/ui/edit_post.dart';
import 'package:hotpins/ui/notifications.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/util/appBar.dart';
import '../model/user.dart';
import '../util/colors.dart';
import 'bottom_map.dart';
import 'explore_screen.dart';
import 'package:hotpins/classes/post.dart';
import "package:hotpins/services/analytics.dart";




class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);
  static const String routeName = "/feedPage";

  @override
  State<FeedPage> createState() => _FeedPageState();
}




class _FeedPageState extends State<FeedPage> {

  List<Post> postsList = [];
  List<OurUser> usersList = [];
  List<String> postIDList = [];
  List<String> userPostIDList = [];
  final CollectionReference postCollection = FirebaseFirestore.instance.collection("Posts");

  var currentUser = OurUser(followRequests: [], follower: [], following: [], posts: [], userId: "", username: "", email: "", private: false, fullName: "", bio: "", bookmark: [], notifications: [], method: "", profilePic: "");
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
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
    setState((){});

    print(currentUser.following);
  }
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
      if(currentUser.following.contains(snapshot.get('userid'))){
        userPostIDList.add(item);
      }
    }
    print(userPostIDList);
    for(var item in userPostIDList){
      print(item);

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
      DocumentSnapshot snapshot3 = await userCollection.doc(snapshot2.get('userid')).get();
      final thatUser =OurUser(
          followRequests: List<String>.from(snapshot3.get('FollowRequests')),
          userId: snapshot3.get('id'),
          fullName: snapshot3.get('fullname'),
          email: snapshot3.get('email'),
          method: snapshot3.get('method'),
          follower: List<String>.from(snapshot3.get('Followers')),
          following: List<String>.from(snapshot3.get('Following')),
          posts: List<String>.from(snapshot3.get('Posts')),
          bio: snapshot3.get('bio'),
          bookmark: List<String>.from(snapshot3.get('bookmark')),
          notifications: List<String>.from(snapshot3.get('Followers')),
          private: snapshot3.get('privateAccount'),
          profilePic: snapshot3.get('profilepic'),
          username: snapshot3.get('username'),
      );
      //print(currentPost.picture);
      postsList.add(currentPost);
      usersList.add(thatUser);

      setState((){});

    }


  }


  @override
  void initState() {
    super.initState();
    //scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    getData();
    getPosts();

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

    setCurrentScreen(analytics, "Feed Page", "feedPage.dart") ;
    return  Scaffold(
      appBar: pageBar(context),
          body: SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  for (int i=0; i<postsList.length; i++ )

                    card(postsList[i],
                        usersList[i].username,
                        "",
                        postsList[i].category,
                        postsList[i].location,
                        postsList[i].caption,
                        postsList[i].picture, (){Navigator.push(context, MaterialPageRoute(builder: (context) => AddComment(data: postsList[i],)));},
                        context, (){setState((){});}, usersList[i], (){})


                ]
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
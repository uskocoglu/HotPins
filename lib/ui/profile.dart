import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotpins/model/notif.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/services/authentication.dart';
import 'package:hotpins/ui/explore_screen.dart';
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/ui/profile_follower_list.dart';
import 'package:hotpins/ui/profile_following_list.dart';
import 'package:hotpins/ui/zoomed_pp.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/model/user.dart';
import 'package:hotpins/model/Posts.dart';
import 'package:hotpins/ui/post_card.dart';
import '../classes/post.dart';
import 'FeedPage.dart';
import 'package:hotpins/services/database.dart';
import 'package:hotpins/model/Posts.dart';

import 'add_comment.dart';
import 'bottom_map.dart';
import 'create_post_text.dart';
import 'edit_post.dart';


void main() => runApp(const Profile());

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
  static const String routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    setCurrentScreen(analytics, "Profile Page", "profile.dart") ;
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  List<Post> postsList = [];
  List<String> postIDList = [];
  List<String> userPostIDList = [];
  final x =Post(caption: 'Starbucks',
      date: 'January 20',
      likes: ["aasd", "asdfas"],
      dislikes: ["saldf", "asdfasd"],
      comments: ["asdfas", "asdf"],
      location: "Kadıköy",
      picture: "link",
      category: "asdfa",
      postId: "asdasd",
      userId: "asdfasd",
      postingTime: "sadfsd",
      title: "sdfdsg",

  );
  final CollectionReference postCollection = FirebaseFirestore.instance.collection("Posts");


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
  final _fireStore = FirebaseFirestore.instance;
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
      if(snapshot.get('userid') == currentUser.userId){
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
  @override
  void initState() {
    super.initState();
    //scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    getData();
    getPosts();

  }

  void _goSettingPage(){
    Navigator.pushNamedAndRemoveUntil(context, ProfileEdit.routeName, (route) => false);
  }



  void deletePost(Post post) {
    setState(() {

    });
  }

  void LikeIncrementer(Post post){
    setState(() {


    });
  }
  @override
  Widget build(BuildContext context) {
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
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: SizeConfig.blockSizeVertical*2),
            child: GestureDetector(
                onTap: _goSettingPage,
                child: const Icon(
                  Icons.settings,
                  size: 27,
                )
            ),
          )
        ],
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
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ZoomedProfilePicture(data: currentUser.profilePic)));
                              },
                              child: Image.network(
                                currentUser.profilePic,
                                fit: BoxFit.fill,
                                width: SizeConfig.screenWidth/3,
                              ),
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
                                  currentUser.username,
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
                                      currentUser.posts.length.toString(),
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
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileFollowerList()));
                                      },
                                      child: Text(currentUser.follower.length.toString(),
                                        style: profileTextStyle),
                                    ),
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
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileFollowingList()));
                                      },
                                      child: Text(currentUser.following.length.toString(),

                                        style: profileTextStyle),
                                    ),
                                  ),
                                  Text('Following',
                                    style: profileTextStyle)
                                ],
                              ),
                            ],
                          ),

                          Row(
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

                                      },
                                      child: GestureDetector(
                                        onTap:  _goSettingPage,
                                        child: Text(
                                          "Edit Profile",
                                          style: loginTextStyle,

                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ]
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24,8,24,24),
                      child: SizedBox(width: SizeConfig.screenWidth*0.86, child: Text(currentUser.bio, style: const TextStyle(fontSize: 18),)),
                    ),
                  ],
                ),

                Column(
                    children: <Widget>[
                      for (int i=0; i<postsList.length; i++ )

                        card(postsList[i],
                            currentUser.username,
                            "",
                            postsList[i].category,
                            postsList[i].location,
                            postsList[i].caption,
                            postsList[i].picture, (){Navigator.push(context, MaterialPageRoute(builder: (context) => AddComment(data: postsList[i],)));},
                            context, (){setState((){});}, currentUser, (){Navigator.push(context, MaterialPageRoute(builder: (context) => EditPost(data: postsList[i],)));})

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
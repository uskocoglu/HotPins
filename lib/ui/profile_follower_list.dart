import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/ui/FeedPage.dart';

import 'package:hotpins/ui/other_profile.dart';

import '../model/user.dart';
import 'explore_screen.dart';

class ProfileFollowerList extends StatefulWidget {
  const ProfileFollowerList({Key? key}) : super(key: key);

  @override
  State<ProfileFollowerList> createState() => _ProfileFollowerListState();
}

class _ProfileFollowerListState extends State<ProfileFollowerList> {
  final TextEditingController? _textEditingController = TextEditingController();
  List<String> categoriesOnSearch = [];
  List<String> userIDList = [];
  List<OurUser> usersList = [];
  List<String> categories = [
    'food',
    'sport',
    'history',
    'entertainment',
    'cafe',
  ];
  String query = "";
  final CollectionReference _firebaseFirestore = FirebaseFirestore.instance.collection("Users");

  var currentUser = OurUser(followRequests: [], follower: [], following: [], posts: [], userId: "", username: "", email: "", private: false, fullName: "", bio: "", bookmark: [], notifications: [], method: "", profilePic: "");
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  Future<void> getUsers() async {
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

    print(currentUser.following);

  }
  @override
  void initState() {
    super.initState();
    //scrollController = FixedExtentScrollController(initialItem: selectedListIndex);
    getUsers();

  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    setCurrentScreen(analytics, "Profile Following Page", "profile_following_list.dart") ;
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
          backgroundColor: AppColors.mainColor,
          title: Container(
            decoration: BoxDecoration(color: AppColors.headingColor,
                borderRadius: BorderRadius.circular(30)),
            child: TextField(
              onChanged: (value){
                setState((){
                  query = value;
                  categoriesOnSearch = categories.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList();
                });
              },
              controller: _textEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(SizeConfig.blockSizeVertical),
                  hintText: 'Search'

              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: (){
                categoriesOnSearch.clear();
                _textEditingController!.clear();
                setState((){
                  _textEditingController!.text= '';
                  query = "";
                });
              },
              child: const Icon(
                Icons.close,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firebaseFirestore.snapshots(),
            builder: (context, snapshots){
              return (snapshots.connectionState == ConnectionState.waiting)
                  ?const Center(
                child: CircularProgressIndicator(),
              )
                  :ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index){
                    var data = snapshots.data!.docs[index].data() as Map<String, dynamic>;
                    if(query.isEmpty && currentUser.follower.contains(data['id'])){
                      return ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfilePage(data: data,)));
                        },
                        title: Text(data['username'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primary),),
                        subtitle:Text(data['fullname'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primary),),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['profilepic']),),);
                    }
                    if((data['username'].toString().contains(query.toLowerCase()) || data['fullname'].toString().contains(query.toLowerCase())) && currentUser.follower.contains(data['id'])){
                      return ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfilePage(data: data,)));
                        },
                        title: Text(data['username'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primary),),
                        subtitle:Text(data['fullname'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.primary),),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['profilepic']),),);
                    }



                    return Container();
                  });
            }),

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

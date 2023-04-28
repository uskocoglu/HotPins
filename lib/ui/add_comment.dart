import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/classes/notif_card.dart';
import 'package:hotpins/model/notif.dart';
import 'package:hotpins/model/user.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/ui/explore_screen.dart';
import 'package:hotpins/ui/feedPage.dart';

import '../classes/chatCard.dart';
import '../model/Posts.dart';
import '../util/styles.dart';

class AddComment extends StatefulWidget {
  const AddComment({Key? key, required this.data}) : super(key: key);
  static const String routeName = "/addComment";
  //const AddComment({required this.data});

  final Post data;

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final _formKey = GlobalKey<FormState>();
  String commentDone = "";
  String displayedComment = "";
  var currentUser = OurUser(
      followRequests: [],
      follower: [],
      following: [],
      posts: [],
      userId: "",
      username: "",
      email: "",
      private: false,
      fullName: "",
      bio: "",
      bookmark: [],
      notifications: [],
      method: "",
      profilePic: "");
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('Posts');
  final CollectionReference commentCollection =
      FirebaseFirestore.instance.collection('Comments');
  final CollectionReference notifCollection =
      FirebaseFirestore.instance.collection('Notifications');

  Future<void> addComment(String comment) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('Comments').doc();
    ref.set({
      'comment': comment,
      'id': ref.id,
      'post_id': widget.data.postId,
      'user_id': user.uid,
    });
    DocumentSnapshot snapshot2 =
        await postCollection.doc(widget.data.postId).get();
    var commentArray = List<String>.from(snapshot2.get('comments'));
    print(commentArray);
    commentArray.add(ref.id);
    print(commentArray);
    postCollection.doc(widget.data.postId).update({
      "comments": commentArray,
    });
    DocumentReference ref2 =
        FirebaseFirestore.instance.collection('Notifications').doc();
    ref2.set({
      'id': ref2.id,
      'notif_type': 'comment',
      'other_user_id': user.uid,
      'post_id': widget.data.postId,
      'user_id': widget.data.userId,
    });

    //widget.data.comments.add(ref.id);
    setState(() {});
  }

  Future<void> getUserCredentials(String commentID) async {
    DocumentSnapshot snapshot = await commentCollection.doc(commentID).get();

    var userID = snapshot.get('user_id');
    DocumentSnapshot snapshot2 = await userCollection.doc(userID).get();
    currentUser.userId = snapshot2.get('id');
    currentUser.fullName = snapshot2.get('fullname');
    currentUser.email = snapshot2.get('email');
    currentUser.method = snapshot2.get('method');
    currentUser.follower = List<String>.from(snapshot2.get('Followers'));
    currentUser.following = List<String>.from(snapshot2.get('Following'));
    currentUser.posts = List<String>.from(snapshot2.get('Posts'));
    currentUser.bio = snapshot2.get('bio');
    currentUser.bookmark = List<String>.from(snapshot2.get('bookmark'));
    currentUser.notifications = List<String>.from(snapshot2.get('Followers'));
    currentUser.private = snapshot2.get('privateAccount');
    currentUser.profilePic = snapshot2.get('profilepic');
    currentUser.username = snapshot2.get('username');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Add Comment", "add_comment.dart");
    SizeConfig().init(context);

    return Scaffold(
      appBar: welcomeBar("Comments"),
      body: StreamBuilder<QuerySnapshot>(
          stream: commentCollection.snapshots(),
          builder: (context, snapshots) {
            return Form(
              key: _formKey,
              child: Stack(
                children: [
                  ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;
                        getUserCredentials(data['id']);
                        if (data['post_id'] == widget.data.postId) {
                          return ListTile(
                            onTap: () {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfilePage(data: data,)));
                            },
                            title: Text(
                              currentUser.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.primary),
                            ),
                            subtitle: Text(
                              data['comment'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.primary),
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(currentUser.profilePic),
                            ),
                          );
                        }
                        return Container();
                      }),
                  Positioned(
                    bottom: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        height: SizeConfig.screenHeight / 8,
                        margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 5,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            color: AppColors.inputColor,
                            padding:
                                EdgeInsets.all(SizeConfig.blockSizeHorizontal),
                            child: TextFormField(
                              maxLines: 3,
                              cursorColor: AppColors.textColor,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.comment,
                                  color: AppColors.textColor,
                                ),
                                hintText: "Type Here",
                                hintStyle: TextStyle(
                                  height: 2.4,
                                ),
                                border: InputBorder.none,
                              ),
                              onSaved: (value) {
                                commentDone = value ?? '';
                              },
                            ),
                          ),
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: SizeConfig.screenHeight / 15,
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 10,
                          vertical: 20),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: FlatButton(
                            color: AppColors.buttonColor,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print(commentDone);
                                _formKey.currentState!.save();
                                addComment(commentDone);
                                //setState((){});
                              }
                            },
                            child: Text(
                              "Add Comment",
                              style: welcomeButtonTextStyle,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

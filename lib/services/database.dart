import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hotpins/model/user.dart';

class DatabaseService{
  final String id;
  final List<dynamic> ids;

  DatabaseService({required this.id, required this.ids});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');
  final CollectionReference locationCollection = FirebaseFirestore.instance.collection('Locations');
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('Notifications');
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('Posts');
  final CollectionReference topicCollection = FirebaseFirestore.instance.collection('Topics');

  final Reference firebaseStorageRef = FirebaseStorage.instance.ref();

   OurUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return OurUser(
      followRequests: snapshot.get('FollowRequests'),
      userId: id,
      fullName: snapshot.get('fullname'),
      email: snapshot.get('email'),
      method: snapshot.get('method'),
      follower: snapshot.get('Followers'),
      following: snapshot.get('Following'),
      posts: snapshot.get('Posts'),
      bio: snapshot.get('bio'),
      bookmark: snapshot.get('bookmark'),
      notifications: snapshot.get('notifications'),
      private: snapshot.get('privateAccount'),
      profilePic: snapshot.get('profilepic'),
      username: snapshot.get('username'),
    );
  }
  Stream<OurUser> get userData {
    return userCollection.doc(id).snapshots().map(_userDataFromSnapshot);
  }
  Future addUser(String? fullname, String? email, String method, String? photoURL) async {
    List<String> emptyList = [];
    int num = 0;
    String emptyString = "";
    bool value = false;


    await userCollection
        .doc(id)
        .set({
      'id': id,
      'fullname': fullname,
      'email': email,
      'method': method,
      'FollowRequests': emptyList,
      'Followers': emptyList,
      'Following': emptyList,
      'Posts': emptyList,
      'bio': emptyString,
      'bookmark': emptyList,
      'notifications': emptyList,
      'privateAccount': value,
      'profilepic': photoURL,
      'username': id,

    })
        .then((value) => print('User Added'))
        .catchError((error) => print('Adding user failed ${error.toString()}'));
  }
  Future addUserWithEmailAndPassword(String? name, String? surname, String? email, String? username, String method, String? photoURL) async {
    List<String> emptyList = [];
    int num = 0;
    String emptyString = "";
    bool value = false;
    String fullname = name! + " " + surname!;


    await userCollection
        .doc(id)
        .set({
      'id': id,
      'fullname': fullname,
      'email': email,
      'method': method,
      'FollowRequests': emptyList,
      'Followers': emptyList,
      'Following': emptyList,
      'Posts': emptyList,
      'bio': emptyString,
      'bookmark': emptyList,
      'notifications': emptyList,
      'privateAccount': value,
      'profilepic': photoURL,
      'username': username,

    })
        .then((value) => print('Customer Added'))
        .catchError((error) => print('Adding customer failed ${error.toString()}'));
  }
  Future changeName(String fullname) async {
    await userCollection.doc(id).update({'fullname': fullname});
  }


}
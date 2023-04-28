import 'Posts.dart';
import 'notif.dart';

class OurUser {
  List<String> followRequests;
  List <String> follower;
  List <String> following;
  List <String> posts;
  String userId;
  String username;
  String email;
  bool private;
  String fullName;
  String bio;
  List <String> bookmark;
  List <String> notifications;
  String method;
  String profilePic;



  OurUser({
    required this.followRequests,
    required this.follower,
    required this.following,
    required this.posts,
    required this.userId,
    required this.username,
    required this.email,
    required this.private,
    required this.fullName,
    required this.bio,
    required this.bookmark,
    required this.notifications,
    required this.method,
    required this.profilePic
  });
}


class Post {
  String caption;
  String date;
  List <String> likes;
  List <String> dislikes;
  List <String> comments;
  String location;
  String picture;
  String category;
  String userId;
  String postId;
  String postingTime;
  String title;


  Post({
    required this.caption,
    required this.date,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.location,
    required this.picture,
    required this.category,
    required this.userId,
    required this.postId,
    required this.postingTime,
    required this.title,

  });
}

var title;
var caption;
var topic;
var location;
var cityPost;
var countryPost;
var streetPost;
var subAdministrativePost;
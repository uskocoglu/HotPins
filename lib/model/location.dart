import 'package:flutter/material.dart';

import 'Posts.dart';

class Location {
  double longtitude;
  double latitude;
  List <Post> post;
  String country;
  String city;


  Location({
    required this.longtitude,
    required this.latitude,
    required this.post,
    required this.country,
    required this.city
});
}


dynamic LocationName = "Please Select a Location";
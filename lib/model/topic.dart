import 'package:flutter/material.dart';

import 'Posts.dart';


class Topic{
  String name;
  List <Post> posts;

  Topic({
    required this.name,
    required this.posts,
});
}
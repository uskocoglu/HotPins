import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/classes/notif_card.dart';
import 'package:hotpins/model/notif.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/ui/explore_screen.dart';
import 'package:hotpins/ui/feedPage.dart';

import '../model/Posts.dart';
import '../util/styles.dart';

class ZoomedProfilePicture extends StatefulWidget {
  const ZoomedProfilePicture({Key? key, required this.data}) : super(key: key);
  static const String routeName = "/zoomedPp";
  final String data;

  @override
  State<ZoomedProfilePicture> createState() => _ZoomedProfilePictureState();
}

class _ZoomedProfilePictureState extends State<ZoomedProfilePicture> {
  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Profile photo", "zoomed_pp.dart");
    return Scaffold(
      appBar: welcomeBar("Hot Pins"),
      body: Center(
        child: Container(
          child: Image.network(
              widget.data,
          ),
        ),
      )

    );
  }
}

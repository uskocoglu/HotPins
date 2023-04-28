import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/services/analytics.dart';

import '../util/appBar.dart';


class BottomMap extends StatefulWidget {
  const BottomMap({Key? key}) : super(key: key);
  static const String routeName = "/bottomMap";

  @override
  State<BottomMap> createState() => _BottomMapState();
}

class _BottomMapState extends State<BottomMap> {
  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Bottom Map", "bottom_map.dart") ;
    return Scaffold(
      appBar: welcomeBar("Map"),
      body: GoogleMap(initialCameraPosition: CameraPosition(
          target: LatLng(41.0082, 28.9784), zoom: 14.0),),
    );
  }
}

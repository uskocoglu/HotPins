import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotpins/services/analytics.dart';

import 'package:hotpins/ui/profile.dart';
import 'package:hotpins/ui/profile_edit.dart';
import 'package:hotpins/util/appBar.dart';
import 'package:geolocator/geolocator.dart';
import '../model/Posts.dart';
import '../model/location.dart';
import '../util/colors.dart';
import '../util/dimen.dart';
import '../util/styles.dart';
import 'FeedPage.dart';
import 'explore_screen.dart';
import 'notifications.dart';

class CreatePostLocation extends StatefulWidget {
  static const String routeName = "/createLocation";
  const CreatePostLocation({Key? key}) : super(key: key);

  @override
  State<CreatePostLocation> createState() => _CreatePostLocationState();
}

class _CreatePostLocationState extends State<CreatePostLocation> {
  Future<void> _showDialog(String title, String message) async {
    bool isAndroid = Platform.isAndroid;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if(isAndroid) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          } else {
            return CupertinoAlertDialog(
              title: Text(title, style: welcomeButtonTextStyle),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(message, style: welcomeButtonTextStyle),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }

        });
  }
  List<Marker> myMarker = [];
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
        Navigator.pushNamedAndRemoveUntil(context, ProfileEdit.routeName, (route) => false);
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

  var thePoint;
  var city;
  var country;
  var placeName = "Please Select a Location";
  var lat;
  var long;
  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Choose Location", "choose_location.dart");
    return Scaffold(appBar: welcomeBar("Select A Location"),body: Stack(
      children: [GoogleMap(
        onTap: _handleTap,
        initialCameraPosition: CameraPosition(
            target: LatLng(41.0082, 28.9784), zoom: 14.0),
        markers: Set.from(myMarker),
      ),
      ClipRect(child: Container(margin: EdgeInsetsDirectional.fromSTEB(50, 400,0,0) ,width:300,height: 130,color: Colors.orange, child: Column(
        children: [
          SizedBox(height: 30,),
          Text("$placeName",style: headingTextStyleLocation,),
          IconButton(onPressed: (){ Navigator.pop(context);}, icon: Icon(Icons.add_box_sharp,color: Colors.white,),iconSize: 50),
        ],
      ),)),
      ],
    ),);
  }



  _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
      thePoint = tappedPoint;
    });
    _getLocation(thePoint);
  }
  _getLocation(LatLng thePoint) async{
    List<Placemark> placemarks = await placemarkFromCoordinates(thePoint.latitude,thePoint.longitude);
    lat = thePoint.latitude;
    long = thePoint.longitude;
    city = placemarks.first.administrativeArea.toString();
    country = placemarks.first.country.toString();
    placeName = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.country.toString() + ", " +  placemarks.first.subAdministrativeArea.toString() + ", " +  placemarks.first.street.toString();
    print(placeName);
    LocationName = placeName;
  }
}


/*
    countryPost = placemarks.first.country.toString();
    cityPost = placemarks.first.administrativeArea.toString();
    subAdministrativePost = placemarks.first.subAdministrativeArea.toString();
    streetPost = placemarks.first.street.toString();
*/






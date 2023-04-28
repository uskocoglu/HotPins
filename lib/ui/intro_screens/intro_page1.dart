import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dimen.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenHeight/10,
        ),
        Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeVertical*4),
            child: Container(
                child: Lottie.network('https://assets1.lottiefiles.com/packages/lf20_z1ts6ce4.json'),
            ),
        ),
      Text(
          "Discover New Events and Places" ,
          style: onBoardingTextStyle,
      ),
    ],
    );
  }
}
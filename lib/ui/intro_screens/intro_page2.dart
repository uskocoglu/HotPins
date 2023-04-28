import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dimen.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: SizeConfig.screenHeight/10,
      ),
      Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeVertical*4),
          child: Container(
              child: Lottie.network('https://assets2.lottiefiles.com/packages/lf20_5xqvi8pf.json'),
          ),
      ),
      Text(
          "Get Directions to New Discoveries",
          style: onBoardingTextStyle,
      ),
    ],
    );
  }
}


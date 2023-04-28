import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dimen.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      SizedBox(
        height: SizeConfig.screenHeight/8,
      ),
      Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeVertical*4),
          child: Container(
              child: Lottie.network('https://assets2.lottiefiles.com/private_files/lf30_ac86ifrb.json'),
          ),
      ),
      Text(
          "Discuss Your Experience with People" ,
          style: onBoardingTextStyle2),
    ],
    );
  }
}

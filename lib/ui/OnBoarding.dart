import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/ui/intro_screens/intro_page1.dart';
import 'package:hotpins/ui/intro_screens/intro_page2.dart';
import 'package:hotpins/ui/intro_screens/intro_page3.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/styles.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {

  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Walkthrough Page", "onBoarding.dart") ;
    return SafeArea(
      child: Scaffold(
          body: Container(
            color:  AppColors.primary,
        child: Stack(
          children: [PageView(

            onPageChanged: (index) {
              setState(() {
                onLastPage = (index==2);
              });
            },
            controller: _controller,
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3()
            ],
          ),

          Container(
            alignment: const Alignment(0,0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Text('Skip',
                      style: headingTextStyle),
                  onTap: (){
                _controller.jumpToPage(2);
                },),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const SlideEffect(
                      activeDotColor: AppColors.secondary),
                ),
                onLastPage ? GestureDetector(
                  child: Text(
                      'Get Started',
                      style: headingTextStyle,
                  ),
                  onTap: () async{
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('showHome', true);
                    Navigator.pushNamedAndRemoveUntil(context, "/welcome", (route) => false);
                    },
                ) : GestureDetector(
                  child: Text(
                      'Next',
                      style: headingTextStyle),
                  onTap: (){
                    _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                    },
                ),
              ],
            ),
          ),
        ],
        ),
          ),
      ),
    );

  }
}



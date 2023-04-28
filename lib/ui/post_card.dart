import 'package:flutter/material.dart';
import 'package:hotpins/model/Posts.dart';
import 'package:hotpins/services/analytics.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dimen.dart';

class PostCard extends StatelessWidget {

  static const String routeName = "/postcard";

  final Post post;
  final VoidCallback delete;
  final VoidCallback increment;
  PostCard({required this.post, required this.delete, required this.increment });

  @override
  Widget build(BuildContext context) {
    setCurrentScreen(analytics, "Post Card", "post_card.dart");
    SizeConfig().init(context);
    return Card(
      color: AppColors.headingColor,
      margin: EdgeInsets.all(SizeConfig.blockSizeVertical),

      child: Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              post.caption,
              style: profileNameTextStyle,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: SizeConfig.screenHeight/8,
                  width: SizeConfig.screenWidth/3.5,
                  margin:  EdgeInsets.all(SizeConfig.blockSizeHorizontal),
                  child: Image.network("https://mimarlikdukkani.com/wp-content/uploads/2018/09/starbucks_sabanc%C4%B1-25.jpg"),
                ), 

                const Spacer(),

                Column(
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: increment,
                          icon: const Icon(
                            Icons.thumb_up,
                            size: 18,
                            color: AppColors.mainColor,
                          ),
                          label: Text(
                              post.likes.length.toString(),
                              style: cardTextStyle
                          ),
                        ),

                        SizedBox(width: SizeConfig.blockSizeVertical*2),

                        const Icon(
                          Icons.comment,
                          size: 18,
                          color: AppColors.mainColor,
                        ),

                        SizedBox(width: SizeConfig.blockSizeVertical,),

                        Text(
                            post.comments.length.toString(),
                            style: cardTextStyle
                        ),

                        SizedBox(width: SizeConfig.blockSizeVertical),


                        IconButton(
                          iconSize: 18,
                          onPressed: delete,
                          icon: const Icon(Icons.pin_drop, size: 14, color: AppColors.primary),

                        ),
                      ],
                    ),
                    IconButton(
                      iconSize: 18,
                      onPressed: delete,
                      icon: const Icon(Icons.delete, size: 14, color: AppColors.primary),
                    ),

                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

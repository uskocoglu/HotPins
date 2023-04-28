import 'package:flutter/material.dart';
import 'package:hotpins/model/message.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/util/styles.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
    required this.user,
    required this.image_url,
  }) : super(key: key);

  final ChatMessage message;
  final String user;
  final String image_url;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Row(
        mainAxisAlignment:
        message.sender == user ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (message.sender != user) ...[
            CircleAvatar(
              radius: 12,
              child: Image.network(image_url),
            ),
          ],
          SizedBox(
            width: SizeConfig.blockSizeHorizontal/2,
          ),
          Container(
            margin: message.sender == user ?
            EdgeInsets.fromLTRB(
              SizeConfig.blockSizeHorizontal*4,
              SizeConfig.blockSizeVertical*3,
              SizeConfig.blockSizeHorizontal*2,
              0,
            ) :
            EdgeInsets.fromLTRB(
              SizeConfig.blockSizeHorizontal*2,
              SizeConfig.blockSizeVertical*3,
              SizeConfig.blockSizeHorizontal*3,
              0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal*3,
              vertical: SizeConfig.blockSizeVertical,
            ),
            decoration: BoxDecoration(
              color: message.sender == user ? AppColors.inputColor.withOpacity(0.8) : AppColors.buttonColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),

            child: Flexible(
              child: Text(
                message.text,
                style: chatTextStyle,
                softWrap: false,
                maxLines: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

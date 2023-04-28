import 'package:flutter/material.dart';
import 'package:hotpins/model/chat.dart';
import 'package:hotpins/util/dimen.dart';
import 'package:hotpins/util/styles.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({Key? key, required this.chat, required this.press})
      : super(key: key);

  final Chat chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical,
            horizontal: SizeConfig.blockSizeHorizontal * 5),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  child: Image.network(chat.image),
                  radius: 30,
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 3,
                  horizontal: SizeConfig.blockSizeHorizontal * 8,
                ),
                child: Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: chatTextStyle,
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeHorizontal * 3,
                      ),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          chat.messages.last,
                          style: chatTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

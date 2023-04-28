import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotpins/model/Posts.dart';
import 'package:hotpins/model/user.dart';
import 'package:hotpins/util/colors.dart';
import 'package:hotpins/util/styles.dart';
import 'package:hotpins/util/dimen.dart';

final CollectionReference postCollection = FirebaseFirestore.instance.collection("Posts");
final CollectionReference notifCollection = FirebaseFirestore.instance.collection("Notifications");

final user = FirebaseAuth.instance.currentUser!;
String notifID = "";


Future<void> likePost(Post post) async {
  bool isUpdated = false;
  DocumentSnapshot snapshot = await postCollection.doc(post.postId).get();
  DocumentReference ref2 = FirebaseFirestore.instance.collection('Notifications').doc();
  post.likes = List<String>.from(snapshot.get('likes'));
  post.dislikes = List<String>.from(snapshot.get('dislikes'));

  if (post.dislikes.contains(user.uid)) {
    post.dislikes.remove(user.uid);
    postCollection.doc(post.postId).update({
      'dislikes': post.dislikes,
    });
    //FirebaseFirestore.instance.collection("Notifications").doc(notifID).delete();
    notifCollection.doc(notifID).update({
      'notif_type': 'like',
    });
    isUpdated = true;
  }

  if (post.likes.contains(user.uid)){
    post.likes.remove(user.uid);
    postCollection.doc(post.postId).update({
      'likes': post.likes,
    });

    FirebaseFirestore.instance.collection("Notifications").doc(notifID).delete();

  }
  else{
    post.likes.add(user.uid);
    postCollection.doc(post.postId).update({
      'likes': post.likes,
    });
    if(isUpdated == false){
      ref2.set({
        'id': ref2.id,
        'notif_type': 'like',
        'other_user_id': user.uid,
        'post_id': post.postId,
        'user_id': post.userId,
      });
      notifID = ref2.id;
    }

  }




}
Future<void> dislikePost(Post post) async{
  bool isUpdated2 = false;
  DocumentSnapshot snapshot = await postCollection.doc(post.postId).get();
  DocumentReference ref2 = FirebaseFirestore.instance.collection('Notifications').doc();
  post.dislikes = List<String>.from(snapshot.get('dislikes'));
  post.likes = List<String>.from(snapshot.get('likes'));

  if (post.likes.contains(user.uid)) {
    post.likes.remove(user.uid);
    postCollection.doc(post.postId).update({
      'likes': post.likes,
    });
    notifCollection.doc(notifID).update({
      'notif_type': 'dislike',
    });
    isUpdated2 = true;

  }
  if (post.dislikes.contains(user.uid)){
    post.dislikes.remove(user.uid);
    postCollection.doc(post.postId).update({
      'dislikes': post.dislikes,
    });

    FirebaseFirestore.instance.collection("Notifications").doc(notifID).delete();
  }
  else{
    post.dislikes.add(user.uid);
    postCollection.doc(post.postId).update({
      'dislikes': post.dislikes,
    });
    if(isUpdated2 == false){
      ref2.set({
        'id': ref2.id,
        'notif_type': 'dislike',
        'other_user_id': user.uid,
        'post_id': post.postId,
        'user_id': post.userId,
      });
      notifID = ref2.id;
    }


    //FirebaseFirestore.instance.collection("Notifications").doc(notifID).delete();

  }



  //setState((){});
}
Card card(Post post,String name, String surname, String topic, String location, String comment, String link, Function func, BuildContext context, Function setState,OurUser user2, Function func2) {
  SizeConfig().init(context);
  return Card(
    child: SizedBox(
      height: SizeConfig.screenHeight/2,
      child: Column(
        children: <Widget>[
          SizedBox(height: SizeConfig.blockSizeVertical*3),
          ListTile(
            leading: CircleAvatar(child: Image.network(user2.profilePic),),
            title: Text("$name $surname"),
            subtitle: Text("$topic \n$location"),
            trailing: GestureDetector(child: const Icon(Icons.edit, color: AppColors.secondary), onTap: (){func2();}),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              comment,
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*2),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(link),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if(post.likes.contains(user.uid))
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.thumb_up, color: Colors.green),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                      Text(
                        post.likes.length.toString(),
                        style: cardTextStyle,
                      ),
                    ],
                  ),
                  onTap: ()async{await likePost(post); setState();},
                )
              else
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.thumb_up, color: AppColors.secondary),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                      Text(
                        post.likes.length.toString(),
                        style: cardTextStyle,
                      ),
                    ],
                  ),
                  onTap: ()async{await likePost(post); setState();},
                ),
              if(post.dislikes.contains(user.uid))
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.thumb_down, color: Colors.red),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                      Text(
                        post.dislikes.length.toString(),
                        style: cardTextStyle,
                      ),
                    ],
                  ),
                  onTap: ()async{await dislikePost(post); setState();},
                )
              else
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.thumb_down, color: AppColors.secondary),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                      Text(
                        post.dislikes.length.toString(),
                        style: cardTextStyle,
                      ),
                    ],
                  ),
                  onTap: ()async{await dislikePost(post); setState();},
                ),
              GestureDetector(
                child: Row(
                  children:  <Widget>[
                    const Icon(Icons.comment, color: AppColors.secondary),
                    SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                    Text(
                      post.comments.length.toString(),
                      style: cardTextStyle,
                    ),
                  ],
                ),
                onTap: (){func();},
              ),
              Row(
                children: <Widget>[
                  const Icon(Icons.share, color: AppColors.secondary),
                  SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                  Text(
                    "Share",
                    style: cardTextStyle,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeVertical*4,),
        ],
      ),
    ),
  );
}

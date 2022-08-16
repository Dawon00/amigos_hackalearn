import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime createddate = post.dateTime;
    String formatteddate = DateFormat('yyyy-MM-dd').format(createddate);
    late final len;

    Stream<String> countComments() async* {
      while (true) {
        await Future.delayed(Duration(milliseconds: 500));
        final QuerySnapshot qSnap = await FirebaseFirestore.instance
            .collection('posts')
            .doc(post.id)
            .collection('comments')
            .get();

        final String documentlen = qSnap.docs.length.toString();
        yield documentlen;
      }
    }

    //len = countComments();

    return Column(
      children: <Widget>[
        Card(
          color: whiteColor,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.transparent)),
          shadowColor: primaryColor,
          elevation: 11.0,
          margin: const EdgeInsets.all(30),
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(post.profileImg),
                ),
                title: Text(
                  post.author + '님 ' + post.saved.toString() + '원 절약 완료!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular'),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              //게시물 사진
              Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Image.network(post.photoUrl))),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<String>(
                    stream: countComments(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        // while data is loading:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final len = snapshot.data;
                        return Text(
                          len!,
                          style: TextStyle(color: Colors.black),
                        );
                      }
                    }),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child:
                        Icon(CupertinoIcons.bubble_right, color: Colors.black),
                  )
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

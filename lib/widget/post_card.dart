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

    countComments() async {
      final QuerySnapshot qSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('comments')
          .get();

      final String documentlen = qSnap.docs.length.toString();
      return documentlen;
    }

    //len = countComments();

    return Column(
      children: <Widget>[
        FutureBuilder<String>(
          future: countComments(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final len = snapshot.data;
              return Card(
                color: whiteColor,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                margin: const EdgeInsets.all(30),
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(post.profileImg),
                      ),
                      title: Text(
                        post.author,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                        child: Text(
                          post.postTitle,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    //게시물 사진
                    Center(child: Image.network(post.photoUrl)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(25, 10, 0, 0),
                        child: Text(
                          post.content,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(
                            flex: 20,
                          ),
                          Text(
                            formatteddate,
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(
                            flex: 4,
                          ),
                          Text(
                            post.saved.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(),
                          Text(
                            '원 절약',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(
                            len!,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Icon(CupertinoIcons.bubble_right,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ]),
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}

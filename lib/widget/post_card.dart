import 'package:amigos_hackalearn/utils/colors.dart';
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

    return Column(
      children: <Widget>[
        Card(
          color: whiteColor,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.all(30),
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              ListTile(
                leading: CircleAvatar(),
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
              Center(child: Image.network(post.profileImg)),
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
                    )
                  ],
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }
}

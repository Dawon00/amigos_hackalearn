import 'package:flutter/material.dart';

import '../model/post.dart';

class PostCard extends StatelessWidget {
  //final Post post;
  //const PostCard({Key? key, required this.post}) : super(key: key);
  const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.all(30),
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(children: <Widget>[
              ListTile(
                leading: CircleAvatar(),
                title: Text('유저 닉네임'),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Text(
                    "게시물 제목",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Center(
                child: Container(
                  height: 350,
                  width: 350,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 0, 0),
                  child: Text(
                    "게시물 내용입니다.",
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Align(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Icon(Icons.mode_comment_outlined), Text('  3')],
                  ),
                ),
                alignment: Alignment.centerRight,
              )
            ]),
          ),
        )
      ],
    );
  }
}

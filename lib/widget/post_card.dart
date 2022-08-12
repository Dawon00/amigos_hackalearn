import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime createddate = post.dateTime;
    String formatteddate = DateFormat('yyyy-MM-dd kk:mm').format(createddate);

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
                title: Text(post.author),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                  child: Text(
                    post.postTitle,
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
                    post.content,
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(formatteddate),
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.mode_comment_outlined),
                        Text('  3')
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        )
      ],
    );
  }
}

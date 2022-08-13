import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/post.dart';

class DetailScreen extends StatefulWidget {
  final Post post;
  final String uid;
  const DetailScreen({Key? key, required this.post, required this.uid})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime createddate = widget.post.dateTime;
    String formatteddate = DateFormat('yyyy-MM-dd kk:mm').format(createddate);

    return Scaffold(
        appBar: AppBar(title: Text(widget.post.postTitle)),
        body: Column(
          children: <Widget>[
            Card(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              margin: const EdgeInsets.all(30),
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 14,
                  ),
                  //게시물 사진
                  Container(
                    child: Text('Image'),
                  ),
                  //Center(child: Image.network(widget.post.photoUrl)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25, 10, 0, 0),
                      child: Text(
                        widget.post.content,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  //발행 날짜
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Text(formatteddate)],
                    ),
                  ),
                  //프로필 사진 & author
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text(widget.post.author),
                  ),
                ]),
              ),
            )
          ],
        ));
  }
}

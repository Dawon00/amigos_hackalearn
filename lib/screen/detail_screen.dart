import 'dart:html';

import 'package:amigos_hackalearn/screen/post_screen.dart';
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    String formatteddate = DateFormat('yyyy-MM-dd').format(createddate);
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: whiteColor,
          title: Text(
            widget.post.postTitle,
            style: TextStyle(color: primaryColor),
          ),
          actions: currentUid == widget.post.uid
              ? <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                      //수정상태와 최초 글쓰기 상태를 PostScreen에서 설정해줘야
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostScreen(uid: widget.post.uid)));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: primaryColor,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('게시글 삭제'),
                          content: Text('게시글을 삭제할까요?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                '취소',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                '확인',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () async {
                                Navigator.of(ctx).pop(true);
                                try {
                                  Navigator.pop(context);
                                  final FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;
                                  firestore
                                      .collection('posts')
                                      .doc(widget.post.id)
                                      .delete();
                                } catch (error) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                      "삭제하지 못했습니다.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ));
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ]
              : null,
        ),
        body: SingleChildScrollView(
          child: Column(
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
                    //프로필 사진 & author
                    ListTile(
                      leading: CircleAvatar(),
                      title: Text(
                        widget.post.author,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    //게시물 사진
                    Center(child: Image.network(widget.post.photoUrl)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(25, 10, 0, 0),
                        child: Text(
                          widget.post.content,
                          style: TextStyle(color: Colors.black),
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
                            widget.post.saved.toString(),
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
          ),
        ));
  }
}

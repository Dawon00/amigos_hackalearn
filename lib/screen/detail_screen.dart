import 'package:amigos_hackalearn/model/user.dart' as model;
import 'package:amigos_hackalearn/screen/home_screen.dart';
import 'package:amigos_hackalearn/screen/post_screen.dart';
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
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
  late final model.User user;
  bool isLoading = false;

  void setUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      user = model.User.fromSnap(userSnap);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setUser();
  }

  @override
  Widget build(BuildContext context) {
    DateTime createddate = widget.post.dateTime;
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final TextEditingController commentController = TextEditingController();

    countComments() async {
      final QuerySnapshot qSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post.id)
          .collection('comments')
          .get();

      final String documentlen = qSnap.docs.length.toString();
      return documentlen;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(children: [
          Spacer(),
          Image.asset(
            'assets/logo_png.png',
            width: 30,
          ),
          Text(widget.post.postTitle,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'NemojinBold',
              )),
        ]),
        actions: currentUid == widget.post.uid
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: ButtonColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                    //수정상태와 최초 글쓰기 상태를 PostScreen에서 설정해줘야
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostScreen(
                          uid: widget.post.uid,
                          isPost: false,
                          originPost: widget.post,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: ButtonColor,
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('게시글 삭제'),
                        content: const Text('게시글을 삭제할까요?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              '확인',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () async {
                              if (user.uid == widget.post.uid) {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(widget.post.id)
                                      .delete();
                                  await firestore
                                      .collection('users')
                                      .doc(widget.uid)
                                      .update({
                                    'saved':
                                        FieldValue.increment(-widget.post.saved)
                                  });
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                    ),
                                  );
                                }
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
                borderSide: BorderSide(color: Colors.transparent),
              ),
              shadowColor: primaryColor,
              elevation: 11.0,
              margin: const EdgeInsets.all(30),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    //프로필 사진 & author
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(widget.post.profileImg),
                      ),
                      title: Text(
                        widget.post.author +
                            '님 ' +
                            widget.post.saved.toString() +
                            '원 절약 완료!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular'),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    //게시물 사진
                    Center(child: Image.network(widget.post.photoUrl)),
                    const SizedBox(
                      height: 14,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        widget.post.postTitle,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Regular'),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                        child: Text(
                          widget.post.content,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular'),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),
                    //발행 날짜
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            createddate.month.toString() +
                                '월' +
                                createddate.day.toString() +
                                '일의 절약 기록',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                  return Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    alignment: Alignment.centerLeft,
                    child: Container(child: Text('댓글 ' + len! + ' 개')),
                  );
                }
              }),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.post.id)
                  .collection('comments')
                  .orderBy(
                    'datePublished',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => CommentCard(
                    snap: (snapshot.data! as dynamic).docs[index].data(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: isLoading
            ? Container()
            : Container(
                height: kToolbarHeight,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                      radius: 18,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Comment as ${user.username}',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          if (commentController.text.isNotEmpty) {
                            String commentId = const Uuid().v1();
                            await FirebaseFirestore.instance
                                .collection('posts')
                                .doc(widget.post.id)
                                .collection('comments')
                                .doc(commentId)
                                .set({
                              'profileImage': user.photoUrl,
                              'name': user.username,
                              'text': commentController.text,
                              'commentId': commentId,
                              'datePublished': DateTime.now(),
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }

                        setState(() {
                          commentController.text = '';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: const Text(
                          'Post',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profileImage']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular'),
                        ),
                        TextSpan(
                          text: '  ${widget.snap['text']}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Regular'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

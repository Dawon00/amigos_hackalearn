import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/post.dart';
import '../widget/add_post_button.dart';
import '../widget/post_card.dart';
import 'detail_screen.dart';

final firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          '피드',
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('posts')
            .orderBy(
              'dateTime',
              descending: true,
            )
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) => GestureDetector(
                    child: PostCard(
                      post: Post.fromSnap(docs[index]),
                    ),
                    onTap: (() {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => DetailScreen(
                                  post: Post.fromSnap(docs[index]),
                                  uid:
                                      FirebaseAuth.instance.currentUser!.uid)));
                    }),
                  ));
        },
      ),
      floatingActionButton: const AddPostButton(),
    );
  }
}

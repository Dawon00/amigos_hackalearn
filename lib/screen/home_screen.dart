import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widget/add_post_button.dart';
import '../widget/post_card.dart';

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
        title: Text('피드'),
      ),
      body: StreamBuilder(
        stream: firestore.collection('post').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => GestureDetector(
                    child: PostCard(
                        //post: Post.fromSnap(docs[index]),
                        ),
                    onTap: (() {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Scaffold(
                                    body: Text('상세 페이지'),
                                    //DetailScreen 으로 전환
                                  )));
                    }),
                  ));
        },
      ),
      floatingActionButton: const AddPostButton(),
    );
  }
}

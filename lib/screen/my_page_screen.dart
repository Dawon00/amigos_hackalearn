import 'package:amigos_hackalearn/model/post.dart';
import 'package:amigos_hackalearn/model/user.dart' as model;
import 'package:amigos_hackalearn/screen/detail_screen.dart';
import 'package:amigos_hackalearn/screen/login_screen.dart';
import 'package:amigos_hackalearn/screen/profile_edit_screen.dart';
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  final String uid;
  const MyPageScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late model.User user;
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              title: Text(
                '마이페이지',
                style: TextStyle(color: primaryColor),
              ),
              backgroundColor: whiteColor,
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl),
                            backgroundColor: secondaryColor,
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        user.username,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        '님이 지금까지',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '아낀 금액은 ${user.saved.toString()}원',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '총 ${user.implements.length.toString()}일 절약 실천중',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Spacer(
                                      flex: 5,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: primaryColor)))),
                                      onPressed: () async {
                                        if (!mounted) return;
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEditScreen(user: user),
                                          ),
                                        );

                                        setUser();
                                      },
                                      child: const Text(
                                        '프로필 편집',
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: primaryColor)))),
                                      onPressed: () async {
                                        FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        await auth.signOut();
                                        if (!mounted) return;
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        '로그아웃',
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                    post: Post.fromSnap(snap),
                                    uid: widget.uid)));
                          },
                          child: Image(
                            image: NetworkImage(
                                (snap.data()! as dynamic)['photoUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }
}

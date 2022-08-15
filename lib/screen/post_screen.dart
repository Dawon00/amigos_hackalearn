import 'dart:typed_data';
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart' as model;
import 'package:amigos_hackalearn/model/post.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/input_field.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatefulWidget {
  final String uid;
  final bool isPost;
  final originPost;

  const PostScreen({
    Key? key,
    required this.uid,
    this.isPost = true,
    this.originPost,
  }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _postTitlecontroller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Uint8List? _image;

  String postId = const Uuid().v4();
  late final model.User user;
  void setUser() async {
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
  }

  @override
  void initState() {
    super.initState();
    setUser();
    if (!widget.isPost) {
      _postTitlecontroller.text = widget.originPost.postTitle;
      _contentController.text = widget.originPost.content;
      _priceController.text = widget.originPost.saved.toString();
    }
  }

  Future<void> _sendPost(
      {required String postTitle,
      required DateTime dateTime,
      required String content,
      required Uint8List file,
      required String author,
      required String uid,
      required int saved,
      required String profileImg}) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('postImages').child(postId);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String photoUrl = await snapshot.ref.getDownloadURL();
      Post post = Post(
          id: postId,
          author: author,
          postTitle: postTitle,
          dateTime: dateTime,
          content: content,
          photoUrl: photoUrl,
          uid: user.uid,
          saved: saved,
          profileImg: profileImg);
      firestore.collection('posts').doc(postId).set(post.toJson());

      DocumentReference doc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final DateTime now = DateTime.now();
      doc.update(
        {
          "saved": user.saved + saved,
          "implements":
              FieldValue.arrayUnion([DateTime(now.year, now.month, now.day)])
        },
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error ocurred.'),
          content: const Text('오류가 발생했습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> updatePost({
    required String title,
    required String content,
    required int saved,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final FirebaseStorage storage = FirebaseStorage.instance;
      String photoUrl = '';

      if (_image != null) {
        Reference ref =
            storage.ref().child('postImages').child(widget.originPost.id);
        TaskSnapshot snapshot = await ref.putData(_image!);
        photoUrl = await snapshot.ref.getDownloadURL();
      }

      final DocumentReference doc =
          firestore.collection('posts').doc(widget.originPost.id);
      await doc.update({
        "postTitle": title,
        "content": content,
        "photoUrl": photoUrl.isEmpty ? widget.originPost.photoUrl : photoUrl,
        "saved": saved,
      });

      await firestore.collection('users').doc(widget.uid).update(
          {'saved': FieldValue.increment(saved - widget.originPost.saved)});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isPost ? '글쓰기' : '편집하기',
          style: const TextStyle(color: primaryColor),
        ),
        backgroundColor: whiteColor,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              widget.isPost
                  ?
                  // 프로필 이미지 선택 UI
                  _image != null
                      ? Image(
                          image: MemoryImage(_image!),
                          width: 150,
                          height: 150,
                        )
                      : const Image(
                          image: AssetImage('assets/default_photo.png'),
                          width: 150,
                          height: 150,
                        )
                  : _image != null
                      ? Image(
                          image: MemoryImage(_image!),
                          width: 150,
                          height: 150,
                        )
                      : Image(
                          image: NetworkImage(widget.originPost.photoUrl),
                          width: 150,
                          height: 150,
                        ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  // 이미지 선택 기능
                  onPressed: () async {
                    Uint8List img = await pickImage(ImageSource.gallery);
                    setState(
                      () {
                        _image = img;
                      },
                    );
                  },
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text('글 제목'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InputField(
                  textEditingController: _postTitlecontroller,
                  hintText: "글 제목을 입력해주세요",
                  inputType: TextInputType.text,
                ),
              ),
            ],
          ),
          const Spacer(),
          //본문 입력
          Column(
            children: [
              const Text('본문 내용'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InputField(
                    textEditingController: _contentController,
                    hintText: "내용을 입력해주세요",
                    inputType: TextInputType.text),
              ),
            ],
          ),
          const Spacer(),

          Column(
            children: [
              const Text('아낀 금액'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InputField(
                    textEditingController: _priceController,
                    hintText: "금액을 입력해주세요",
                    inputType: TextInputType.number),
              ),
            ],
          ),
          const Spacer(),

          InkWell(
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: whiteColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                color: primaryColor,
              ),
              child: const Text(
                '완료',
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              final int saved = int.parse(_priceController.text);
              final dateTime = DateTime.now();
              //user정보 확인
              if (widget.isPost) {
                _sendPost(
                  postTitle: _postTitlecontroller.text,
                  dateTime: dateTime,
                  content: _contentController.text,
                  file: _image!,
                  author: user.username,
                  uid: user.uid,
                  saved: saved,
                  profileImg: user.photoUrl,
                );
              } else {
                updatePost(
                  title: _postTitlecontroller.text,
                  content: _contentController.text,
                  saved: int.parse(_priceController.text),
                );
              }
            },
          ),
          const Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
    _priceController.dispose();
    _postTitlecontroller.dispose();
  }
}

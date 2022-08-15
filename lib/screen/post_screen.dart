import 'dart:convert';
import 'dart:typed_data';
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amigos_hackalearn/model/post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import '../widget/input_field.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatefulWidget {
  final String uid;

  const PostScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _postTitlecontroller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Uint8List? _image;
  String postId = Uuid().v4();
  var _isLoading = false;
  late final model.User user;
  void setUser() async {
    setState(() {
      _isLoading = true;
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
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setUser();
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
    late String res;
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
      res = "success";
    } catch (e) {
      res = e.toString();
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error ocurred.'),
          content: Text('오류가 발생했습니다.'),
          actions: <Widget>[
            FlatButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  // Future<void> _editPost(){
  //
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '글쓰기',
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: whiteColor,
      ),
      body: Column(
        children: [
          Stack(
            children: [
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
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  // 이미지 선택 기능
                  onPressed: () async {
                    Uint8List img = await pickImage(ImageSource.gallery);
                    setState(() {
                      _image = img;
                    });
                  },
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text('글 제목'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InputField(
                    textEditingController: _postTitlecontroller,
                    hintText: "글 제목을 입력해주세요",
                    inputType: TextInputType.text),
              ),
            ],
          ),
          Spacer(),
          //본문 입력
          Column(
            children: [
              Text('본문 내용'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InputField(
                    textEditingController: _contentController,
                    hintText: "내용을 입력해주세요",
                    inputType: TextInputType.text),
              ),
            ],
          ),
          Spacer(),

          Column(
            children: [
              Text('아낀 금액'),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InputField(
                    textEditingController: _priceController,
                    hintText: "금액을 입력해주세요",
                    inputType: TextInputType.number),
              ),
            ],
          ),
          Spacer(),

          InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  '완료',
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              ),
              onTap: () {
                final int _saved = int.parse(_priceController.text);
                final dateTime = DateTime.now();
                //user정보 확인
                print(user.username);
                _sendPost(
                    postTitle: _postTitlecontroller.text,
                    dateTime: dateTime,
                    content: _contentController.text,
                    file: _image!,
                    author: user.username,
                    uid: user.uid,
                    saved: _saved,
                    profileImg: user.photoUrl);
                String tmpDate = dateTime.year.toString() +
                    dateTime.month.toString() +
                    dateTime.day.toString();

                DocumentReference doc = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid);
                doc.update({
                  "saved": user.saved + _saved,
                  "implements": FieldValue.arrayUnion(['220816'])
                });
                print(user.implements);
              }),
          Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }
}

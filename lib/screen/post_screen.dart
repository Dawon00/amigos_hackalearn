import 'dart:typed_data';

import 'package:amigos_hackalearn/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amigos_hackalearn/model/post.dart';
import 'package:image_picker/image_picker.dart';

import '../widget/upload_image.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _postTitlecontroller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글쓰기'),
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
                      image: AssetImage('assets/dark_logo.png'),
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
              InputField(
                  textEditingController: _postTitlecontroller,
                  hintText: "글 제목을 입력해주세요",
                  inputType: TextInputType.text),
            ],
          ),
          //본문 입력
          Column(
            children: [
              Text('본문 내용'),
              InputField(
                  textEditingController: _contentController,
                  hintText: "내용을 입력해주세요",
                  inputType: TextInputType.text),
            ],
          ),

          Column(
            children: [
              Text('아낀 금액'),
              InputField(
                  textEditingController: _priceController,
                  hintText: "금액을 입력해주세요",
                  inputType: TextInputType.number),
            ],
          ),
          InkWell(
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Text('Flat Button'),
              ),
              onTap: () {
                final int _saved = int.parse(_priceController.text);
                DateTime now = DateTime.now();
                print(_saved);
                //uid 정보 구현전이기때문에 주석처리
                // Post postModel = Post(postTitle:_postTitlecontroller.text ,
                // dateTime: now,  content: _contentController.text, photoUrl: _image)
                //author: , profileImg: ,)
              }),
        ],
      ),
    );
  }
}

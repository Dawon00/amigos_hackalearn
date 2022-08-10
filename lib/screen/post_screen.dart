import 'package:amigos_hackalearn/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _postTitlecontroller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글쓰기'),
      ),
      body: Column(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.add)),
          //제목 입력
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
              Text('사진 등록하기'),
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
        ],
      ),
    );
  }
}

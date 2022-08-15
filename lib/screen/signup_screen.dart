import 'dart:typed_data';

import 'package:amigos_hackalearn/model/user.dart' as model;
import 'package:amigos_hackalearn/screen/index_screen.dart';
import 'package:amigos_hackalearn/screen/login_screen.dart';
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:amigos_hackalearn/widget/input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 메인 컨텐츠 중앙 정렬을 위한 상단 마진
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create your Account',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              // 프로필 이미지 선택 기능
              Stack(
                children: [
                  // 프로필 이미지 선택 UI
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              AssetImage('assets/default_profile.png'),
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
              const SizedBox(
                height: 20,
              ),
              // 사용자 이름 입력 필드
              InputField(
                textEditingController: _usernameController,
                hintText: 'Username',
              ),
              const SizedBox(
                height: 10,
              ),
              // 이메일 입력 필드
              InputField(
                textEditingController: _emailController,
                hintText: 'Email',
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              // 비밀번호 입력 필드
              InputField(
                textEditingController: _passwordController,
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(
                height: 16,
              ),

              // 가입 버튼
              InkWell(
                // tap 이벤트 발생시 가입 진행
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  String res = _image != null
                      ? await signUpUser(
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                          file: _image!,
                        )
                      : 'Please select your profile image';

                  if (res == "success") {
                    if (!mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const IndexScreen(),
                      ),
                    );
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res),
                      ),
                    );
                  }

                  setState(() {
                    _isLoading = false;
                  });
                },
                // 가입 버튼 UI
                child: Container(
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
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        )
                      : const Text(
                          'Sign up',
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              // 메인 컨텐츠 중앙 정렬을 위한 하단 마진
              Flexible(
                flex: 2,
                child: Container(),
              ),

              // 로그인 창으로 이동
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text("계정이 있나요? "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  // 이미지 선택 및 바이트의 리스트 형태로 반환
  Future pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
  }

  // 회원가입 함수
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    late String res;

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseStorage storage = FirebaseStorage.instance;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // 필수 데이터가 비어있을 경우 비어있음을 알리는 메시지 반환
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          file.isEmpty) {
        res = "Please enter all the fields";
      }
      // 데이터가 모두 들어있을 경우
      else {
        // Authentication에 User 생성
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 프로필 이미지 업로드
        Reference ref =
            storage.ref().child('profileImages').child(auth.currentUser!.uid);
        UploadTask uploadTask = ref.putData(file);
        TaskSnapshot snapshot = await uploadTask;
        String photoUrl = await snapshot.ref.getDownloadURL();

        // User 모델 생성
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          username: username,
          photoUrl: photoUrl,
          implements: [],
          saved: 0,
        );

        // User 모델을 json으로 직렬화 하여 database에 저장
        await firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        // 성공 메시지 반환
        res = "success";
      }
    }
    // 오류 발생시 오류 메시지 반환
    catch (e) {
      res = e.toString();
    }

    return res;
  }
}

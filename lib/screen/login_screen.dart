import 'package:amigos_hackalearn/screen/index_screen.dart';
import 'package:amigos_hackalearn/screen/signup_screen.dart';
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:amigos_hackalearn/widget/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

              // // 메인 로고 이미지
              // Image.asset(
              //   'assets/dark_logo.png',
              //   height: 120,
              // ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Login to your Account',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
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

              // 로그인 버튼
              InkWell(
                // tap 이벤트 발생시 로그인 진행
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  String res = await loginUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

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
                // 로그인 버튼 UI
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
                          'Log in',
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

              // 가입 창으로 이동
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text("계정이 없나요? "),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "Sign up",
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
  }

  // 로그인 함수
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    late String res;

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      // 이메일, 비밀번호가 모두 비어있지 않은 경우
      if (email.isNotEmpty && password.isNotEmpty) {
        // 로그인 진행
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // 성공 메시지 반환
        res = "success";
      }
      // 데이터가 비어있을 경우 비어있음을 알리는 메시지 반환
      else {
        res = "Please enter all the fields";
      }
    }
    // 오류 발생시 오류 메시지 반환
    catch (e) {
      res = e.toString();
    }

    return res;
  }
}

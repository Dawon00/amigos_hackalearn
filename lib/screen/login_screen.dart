import 'package:amigos_hackalearn/screen/signup_screen.dart';
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
              Flexible(
                flex: 2,
                child: Container(),
              ),
              // logo
              Image.asset(
                'assets/light_logo.png',
                height: 120,
              ),
              const SizedBox(
                height: 16,
              ),
              // email
              InputField(
                textEditingController: _emailController,
                hintText: 'Email',
                inputType: TextInputType.emailAddress,
              ),
              // password
              InputField(
                textEditingController: _passwordController,
                hintText: 'Password',
                isPassword: true,
              ),
              const SizedBox(
                height: 16,
              ),
              // login button
              InkWell(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  String res = await loginUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  if (res == "success") {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Text(res),
                      ),
                    );
                  } else {
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
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: Color.fromRGBO(0, 149, 246, 1),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              // signup button
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
                      Navigator.of(context).push(
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

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    late String res;

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}

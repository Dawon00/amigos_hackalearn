import 'package:amigos_hackalearn/screen/index_screen.dart';
import 'package:amigos_hackalearn/screen/login_screen.dart';
import 'package:amigos_hackalearn/screen/splash_screen.dart';
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBzH4R5PlQk5gB3qRTViK0K5MzwqArhY5w",
        appId: "1:612032563687:web:c848e0f1ab08287d6b5542",
        messagingSenderId: "612032563687",
        projectId: "amigos-hackalearn",
        storageBucket: "amigos-hackalearn.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amigos',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFFF2F3F8),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const IndexScreen();
            } else if (snapshot.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(snapshot.error.toString()),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return const SplashScreen();
        },
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screen/index_screen.dart';

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
      home: const IndexScreen(),
    );
  }
}

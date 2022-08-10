import 'package:flutter/material.dart';
import '../screen/post_screen.dart';

class AddPostButton extends StatefulWidget {
  const AddPostButton({Key? key}) : super(key: key);

  @override
  State<AddPostButton> createState() => _AddPostButtonState();
}

class _AddPostButtonState extends State<AddPostButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostScreen()),
        );
      },
      child: Container(
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}

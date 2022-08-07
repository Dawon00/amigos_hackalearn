import 'package:flutter/material.dart';

class AddPostButton extends StatefulWidget {
  const AddPostButton({Key? key}) : super(key: key);

  @override
  State<AddPostButton> createState() => _AddPostButtonState();
}

class _AddPostButtonState extends State<AddPostButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Container(
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}

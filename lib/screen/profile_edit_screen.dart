import 'dart:typed_data';

import 'package:amigos_hackalearn/model/user.dart' as model;
import 'package:amigos_hackalearn/utils/colors.dart';
import 'package:amigos_hackalearn/widget/input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  final model.User user;
  const ProfileEditScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController usernameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String uid = widget.user.uid;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ButtonColor,
              size: 30,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            "프로필 편집",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'NemojinBold',
            ),
          ),
        ),
        backgroundColor: whiteColor,
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              try {
                DocumentReference doc =
                    FirebaseFirestore.instance.collection('users').doc(uid);
                String username = usernameController.text;
                String photoUrl = '';

                if (_image != null) {
                  Reference ref = FirebaseStorage.instance
                      .ref()
                      .child('profileImages')
                      .child(uid);
                  TaskSnapshot snapshot = await ref.putData(_image!);
                  photoUrl = await snapshot.ref.getDownloadURL();
                }
                if (photoUrl.isNotEmpty && username.isNotEmpty) {
                  await doc
                      .update({"username": username, "photoUrl": photoUrl});
                } else if (username.isNotEmpty) {
                  await doc.update({"username": username});
                } else if (photoUrl.isNotEmpty) {
                  await doc.update({"photoUrl": photoUrl});
                }

                setState(() {
                  isLoading = false;
                });
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }

              if (isLoading) {
                setState(() {
                  isLoading = false;
                });
              } else {
                if (!mounted) return;
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith(
                (states) => Colors.black.withOpacity(0.1),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    "저장",
                    style: TextStyle(color: Colors.black),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 32,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundColor: ButtonColor,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundColor: ButtonColor,
                          backgroundImage: NetworkImage(widget.user.photoUrl),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
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
              InputField(
                hintText: widget.user.username,
                textEditingController: usernameController,
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
    usernameController.dispose();
  }

  Future pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
  }
}

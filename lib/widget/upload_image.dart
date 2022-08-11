import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// class UploadImg extends StatefulWidget {
//   final String type;
//   const UploadImg({Key? key, required this.type}) : super(key: key);

//   @override
//   State<UploadImg> createState() => _UploadImgState();
// }

// class _UploadImgState extends State<UploadImg> {
//   Uint8List? _image;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Stack(
//         children: [
//           if(widget.type == "profile" ){
//             _image != null?
//               CircleAvatar(
//                   radius: 64,
//                   backgroundImage: MemoryImage(_image!),
//                 )
//               : const CircleAvatar(
//                   radius: 64,
//                   backgroundImage: AssetImage('assets/dark_logo.png'),
//                 );
//         }else if(widget.type == "post"){
//            // 프로필 이미지 선택 UI
//                 _image != null
//                     ? Image(
//                        image: MemoryImage(_image!),
//                       )
//                     : const Image(
//                        image: AssetImage('assets/dark_logo.png'),
//                       ),
//         }

//               ? CircleAvatar(
//                   radius: 64,
//                   backgroundImage: MemoryImage(_image!),
//                 )
//               : const CircleAvatar(
//                   radius: 64,
//                   backgroundImage: AssetImage('assets/dark_logo.png'),
//                 ),
//           Positioned(
//             bottom: -10,
//             left: 80,
//             child: IconButton(
//               // 이미지 선택 기능
//               onPressed: () async {
//                 Uint8List img = await pickImage(ImageSource.gallery);
//                 setState(() {
//                   _image = img;
//                 });
//               },
//               icon: const Icon(Icons.add_a_photo),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

Future pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
}

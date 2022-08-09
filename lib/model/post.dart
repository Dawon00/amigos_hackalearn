import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String postTitle;
  final DateTime dateTime;
  final String photoUrl;
  final String profileImg;
  final String author; // uid
  final String content;
  final int saved;

  Post(
      {this.id = '',
      required this.postTitle,
      required this.dateTime,
      required this.photoUrl,
      required this.profileImg,
      required this.author,
      required this.content,
      required this.saved});

  Post.fromMap(
    Map<String, dynamic> map,
  )   : id = map['id'],
        postTitle = map['postTitle'],
        dateTime = DateTime.parse(map['dateTime'].toString()),
        photoUrl = map['photoUrl'],
        profileImg = map['profileImg'],
        author = map['author'],
        content = map['content'],
        saved = map['saved'];

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      id: snapshot["id"],
      postTitle: snapshot["postTitle"],
      dateTime: snapshot["datetime"].toDate(),
      photoUrl: snapshot["photoUrl"],
      profileImg: snapshot['profileImg'],
      author: snapshot['author'],
      content: snapshot["content"],
      saved: snapshot["saved"],
    );
  }

  Post fromJson(Map<String, dynamic> json) => Post(
      id: json['id'],
      postTitle: json['postTitle'],
      dateTime: json['dateTime'],
      photoUrl: json['photoUrl'],
      profileImg: json['profileImg'],
      author: json['author'],
      content: json['content'],
      saved: json['saved']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "postTitle": postTitle,
        "dateTime": dateTime,
        "photoUrl": photoUrl,
        "profileImg": profileImg,
        "author": author,
        "content": content,
        "saved": saved,
      };
  @override
  String toString() => "Post<$postTitle>";
}

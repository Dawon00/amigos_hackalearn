import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final List implements;
  final int saved;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.implements,
    required this.saved,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "photoUrl": photoUrl,
        "username": username,
        "implements": implements,
        "saved": saved,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      email: snapshot['email'],
      implements: snapshot['implements'],
      saved: snapshot['saved'],
    );
  }
}

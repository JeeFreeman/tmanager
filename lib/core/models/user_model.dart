import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? password;
  UserModel({this.uid, this.name, this.email, this.password});

  factory UserModel.fromFirebase(User? user) {
    return UserModel(
      uid: user?.uid,
      name: user?.displayName,
      email: user?.email,
    );
  }
}

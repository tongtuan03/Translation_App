import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersRef =
  FirebaseFirestore.instance.collection('users');
  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _usersRef.doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,
        });
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
  User? get currentUser => _auth.currentUser;
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<String?> getUsername(String? uid) async {
    if (uid == null) return null;
    final doc = await _usersRef.doc(uid).get();
    if (doc.exists) {
      return doc.get('username') as String?;
    }
    return null;
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotpins/services/database.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userFromFirebase(User? user) {
    return user ?? null;
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      final snapshot = await FirebaseFirestore.instance.collection('customers').doc(user.uid).get();

      if (snapshot == null || !snapshot.exists) {
        await DatabaseService(id: user.uid, ids: []).addUser('Anonymous', 'No Email', 'anonymous', 'noURL');
      }
      return _userFromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future loginWithMailandPass(String mail, String pass) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      User user = result.user!;
      return _userFromFirebase(user);

    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return null;
      } else if (e.code == "wrong-password") {
        return null;
      }
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future sendPasswordLink(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  Future signUp(String name, String surname, String email, String username, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      final snapshot = await FirebaseFirestore.instance.collection('customers').doc(user.uid).get();

      if (snapshot == null || !snapshot.exists) {
        await DatabaseService(id: user.uid, ids: []).addUserWithEmailAndPassword(name, surname, email, username, 'emailandpassword', 'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png');
      }
      return 'Signed Up';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = result.user;

    final snapshot = await FirebaseFirestore.instance.collection('Users').doc(user!.uid).get();

    if (snapshot == null || !snapshot.exists) {
      print('W');
      await DatabaseService(id: user.uid, ids: []).addUser(user.displayName, user.email, 'google', user.photoURL);
    }

    return _userFromFirebase(user);
  }
}
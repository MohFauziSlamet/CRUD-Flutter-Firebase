// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// ================== STREAM PROFILE ==================
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamProfile() async* {
    try {
      /// MENGAMBIL UID USER
      String uid = auth.currentUser!.uid;

      yield* firestore.collection('users').doc(uid).snapshots();
    } catch (e) {
      print(e);
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak Berhasil Mengmbil Data Profile",
        duration: Duration(seconds: 2),
      );
    }
  }

  /// ================== STREAM NOTE ==================
  Stream<QuerySnapshot<Map<String, dynamic>>> streamNote() async* {
    try {
      /// MENGAMBIL UID USER
      String uid = auth.currentUser!.uid;

      yield* firestore
          .collection('users')
          .doc(uid)
          .collection("note")
          .orderBy("createdAt")
          .snapshots();
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak Berhasil Mengmbil Data Note",
        duration: Duration(seconds: 2),
      );
    }
  }

  /// ================== STREAM NOTE ==================
  Future<void> deleteNote({required String id}) async {
    try {
      /// MENGAMBIL UID USER -> UID NOTE
      String uid = auth.currentUser!.uid;

      firestore
          .collection('users')
          .doc(uid)
          .collection("note")
          .doc(id)
          .delete();
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak Berhasil Menghapus Data Note",
        duration: Duration(seconds: 2),
      );
    }
  }
}

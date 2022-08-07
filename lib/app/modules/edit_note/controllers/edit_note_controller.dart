import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNoteController extends GetxController {
  RxBool isLoading = false.obs;
  late TextEditingController titleC;
  late TextEditingController descC;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    titleC = TextEditingController();
    descC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    titleC.dispose();
    descC.dispose();
    super.onClose();
  }

  /// =============== EDIT NOTE ===============
  void editNote({required String id}) async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      try {
        isLoading.value = true;

        /// MENGAMBIL UID USER
        String uid = auth.currentUser!.uid;

        /// MENGUPDATE  DATA USER BERDASARKAN UID
        await firestore
            .collection('users')
            .doc(uid)
            .collection("note")
            .doc(id)
            .update({
          "title": titleC.text,
          "desc": descC.text,
          // "createdAt": DateTime.now().toIso8601String(),
        });

        Get.back();
        Get.snackbar(
          "Berhasil",
          "Berhasil Mengupdate Note",
          duration: Duration(seconds: 2),
        );
      } catch (e) {
        print(e.toString());
        Get.snackbar(
          "Terjadi Kesalahan",
          "Tidak dapat Mengupdate Note",
          duration: Duration(seconds: 2),
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Form tidak boleh kosong",
        duration: Duration(seconds: 2),
      );
    }
  }
}

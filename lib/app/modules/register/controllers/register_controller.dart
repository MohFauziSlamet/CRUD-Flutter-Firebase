import 'package:database_firebase/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  RxBool isHidden = false.obs;
  RxBool isLoading = false.obs;
  late TextEditingController emailC;
  late TextEditingController passC;
  late TextEditingController nameC;
  late TextEditingController phoneC;

  /// INISIASI AUTH
  FirebaseAuth auth = FirebaseAuth.instance;

  /// INISIASI CLOUD FIRESTORE
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void onInit() {
    emailC = TextEditingController();
    passC = TextEditingController();
    nameC = TextEditingController();
    phoneC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }

  void register() async {
    /// CEK EMAIL DAN PASSWORD TIDAK BOLEH KOSONG
    if (emailC.text.isNotEmpty &&
        passC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        phoneC.text.isNotEmpty) {
      /// MENANYAKAN APAKAH BENAR INI FORMAT EMAIL
      if (GetUtils.isEmail(emailC.text)) {
        if (GetUtils.isPhoneNumber(phoneC.text)) {
          try {
            isLoading.value = true;
            final credential = await auth.createUserWithEmailAndPassword(
              email: emailC.text,
              password: passC.text,
            );

            try {
              /// KIRIM EMAIL VERIFIKASI
              await credential.user!.sendEmailVerification();
            } catch (e) {
              if (kDebugMode) {
                print(e.toString());
              }
              Get.snackbar("ERROR",
                  "Tidak Dapat Kirimi Email Verifikasi. Hubungi Admin");
            }

            if (kDebugMode) {
              print(credential);
            }

            /// MEMASUKAN DATA KE CLOUD FIRESTORE
            String uid = credential.user!.uid; // MEMAKAI UID UNTUK MENYIMPAN
            firestore.collection("users").doc(uid).set({
              "name": nameC.text,
              "phone": phoneC.text,
              "email": emailC.text,
              "uid": uid,
              "createdAt": DateTime.now().toIso8601String(),
            });

            /// MENAMPILKAN DIALOG UNTUK VERIFIKASI
            Get.defaultDialog(
              title: "VERIFIKASI",
              middleText:
                  "Berhasil Registrasi. Buka Email dan Lakukan Verifikasi Email",
              barrierDismissible: false,
              textConfirm: "SAYA MENGERTI",
              onConfirm: () {
                Get.back();
                Get.offAllNamed(Routes.LOGIN);
                Get.snackbar(
                    "Berhasil", "Cek Email Kamu Dan Lakukan Verifikasi");
              },
            );

            ///
          } on FirebaseAuthException catch (e) {
            if (kDebugMode) {
              print(e.code);
            }
            if (e.code == 'weak-password') {
              // print('The password provided is too weak.');
              Get.snackbar("Terjadi Kesalahan", "Password terlalu lemah");
            } else if (e.code == 'email-already-in-use') {
              // print('The account already exists for that email.');
              Get.snackbar("Terjadi Kesalahan", "Email Telah Tersedia");
            }
          } catch (e) {
            if (kDebugMode) {
              print(e.toString());
            }

            /// KETIKA ERROR SECARA GENERAL
            Get.snackbar(
                "Terjadi Kesalahan", "Tidak dapat Registrasi. Hubungi Admin!");
          } finally {
            isLoading.value = false;
          }
        } else {
          /// KETIKA NOMOR YANG DIMASUKAN BUKAN NOMOR HANDPHONE
          Get.snackbar("Terjadi Kesalahan",
              "Nomor Yang Anda Masukan, Bukan Nomor Handphone");
        }
      } else {
        /// KETIKA EMAIL YANG DIMASUKAN BUKAN EMAIL
        Get.snackbar(
            "Terjadi Kesalahan", "Email Yang Anda Masukan, Bukan Email");
      }
    } else {
      /// KETIKA ADA FORM YANG TIDAK DIISI
      Get.snackbar("Terjadi Kesalahan", "Semua Form Harus Diisi");
    }
  }
}

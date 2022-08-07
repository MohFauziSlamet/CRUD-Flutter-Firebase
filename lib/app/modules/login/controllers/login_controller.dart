// ignore_for_file: avoid_print

import 'package:database_firebase/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  RxBool isHidden = false.obs;
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;
  late TextEditingController emailC;
  late TextEditingController passC;
  FirebaseAuth auth = FirebaseAuth.instance;
  final box = GetStorage();

  @override
  void onInit() {
    emailC = TextEditingController();
    passC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }

  void login() async {
    /// CEK EMAIL DAN PASSWORD TIDAK BOLEH KOSONG
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      if (GetUtils.isEmail(emailC.text)) {
        try {
          isLoading.value = true;
          final UserCredential credential =
              await auth.signInWithEmailAndPassword(
            email: emailC.text,
            password: passC.text,
          );

          print(credential);

          /// CEK , APAKAH EMAIL SUDAH DIVERIFIKASI
          if (credential.user!.emailVerified == true) {
            /// CEK BOX STORAGE KOSONG APA TIDAK
            if (box.read("rememberme") != null) {
              await box.remove("rememberme");
            }

            if (rememberMe.isTrue) {
              await box.write("rememberme", {
                "email": emailC.text,
                "pass": passC.text,
              });
            }
            Get.offAllNamed(Routes.HOME);
            Get.snackbar("Berhasil", "Anda Berhasil Login");
          } else {
            Get.defaultDialog(
              title: "Belum Terverifikasi",
              middleText: "Apakah Kamu Ingin Mengirim Ulang Email Verifkasi ?",
              actions: [
                /// TIDAK
                OutlinedButton(
                  onPressed: () {
                    Get.back(); // MENUTUP DIALOG
                  },
                  child: const Text("TIDAK"),
                ),

                /// YA
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await credential.user!.sendEmailVerification();
                      Get.back(); // MENUTUP DIALOG
                      Get.snackbar(
                          "BERHASIL", "Cek Email Kamu dan Lakukan Verfikasi");
                    } catch (e) {
                      print(e.toString());
                      Get.back(); // MENUTUP DIALOG
                      Get.snackbar("ERROR",
                          "Kirim Verifikasi Gagal. Coba Lagi 5 Menit Lagi");
                    }
                  },
                  child: const Text("KIRIM KEMBALI"),
                ),
              ],
            );
          }
        } on FirebaseAuthException catch (e) {
          print(e.code);
          if (e.code == 'user-not-found') {
            // print('No user found for that email.');
            Get.snackbar(
                "Terjadi Kesalahan", "Email Yang Anda Masukan Tidak Tersedia");
          } else if (e.code == 'wrong-password') {
            // print('Wrong password provided for that user.');
            Get.snackbar(
                "Terjadi Kesalahan", "Password Yang Anda Masukan Salah");
          }
        } catch (e) {
          print(e.toString());
          Get.snackbar(
              "Terjadi Kesalahan", "Tidak dapat login. Hubungi Admin!");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
            "Terjadi Kesalahan", "Email Yang Anda Masukan, Bukan Email");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Semua Form Harus Diisi");
    }
  }
}

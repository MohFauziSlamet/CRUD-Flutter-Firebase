import 'package:database_firebase/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  late TextEditingController emailC;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    emailC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }

  void resetPassword() async {
    /// CEK EMAIL DAN PASSWORD TIDAK BOLEH KOSONG
    if (emailC.text.isNotEmpty) {
      /// MENANYAKAN APAKAH BENAR INI FORMAT EMAIL
      if (GetUtils.isEmail(emailC.text)) {
        isLoading.value = true;
        try {
          await auth.sendPasswordResetEmail(
            email: emailC.text,
          );

          /// MENAMPILKAN DIALOG UNTUK VERIFIKASI
          Get.defaultDialog(
            title: "VERIFIKASI",
            middleText:
                "Berhasil Reset Password. Buka Email dan Lakukan Reset Password",
            barrierDismissible: false,
            textConfirm: "SAYA MENGERTI",
            onConfirm: () {
              Get.back();
              Get.offAllNamed(Routes.LOGIN);
              Get.snackbar(
                  "Berhasil", "Cek Email Kamu Dan Lakukan Reset Password");
            },
          );
        } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print(e.code);
          }
          Get.snackbar("Terjadi Kesalahan", e.code);
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
          Get.snackbar("Terjadi Kesalahan",
              "Tidak dapat Reset Password. Hubungi Admin!");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
            "Terjadi Kesalahan", "Email Yang Anda Masukan, Bukan Email");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email Harus Diisi");
    }
  }
}

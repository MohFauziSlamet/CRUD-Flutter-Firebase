import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:database_firebase/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as fbStorage;

class ProfileController extends GetxController {
  RxBool isHidden = false.obs;
  RxBool isLoading = false.obs;
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController phoneC;
  late TextEditingController passC;

  fbStorage.FirebaseStorage storage = fbStorage.FirebaseStorage.instance;

  @override
  void onInit() {
    emailC = TextEditingController();
    nameC = TextEditingController();
    phoneC = TextEditingController();
    passC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    phoneC.dispose();
    passC.dispose();
    super.onClose();
  }

  /// ================== LOGOUT ==================
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar("Berhasil", "Anda Berhasil Logout");
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak Berhasil Logout. Hubungi Admin",
        duration: Duration(seconds: 2),
      );
    }
  }

  /// ================== LOGOUT ==================
  Future<Map<String, dynamic>?> getDataUser() async {
    try {
      /// MENGAMBIL UID USER
      String uid = auth.currentUser!.uid;

      /// MENGAMBIL DATA USER BERDASARKAN UID
      var data = await firestore.collection('users').doc(uid).get();

      return data.data();
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak Berhasil Mengambil Data User",
      );
      return null;
    }
  }

  /// ================== UPDATE PROFILE ==================
  void updateProfile() async {
    if (nameC.text.isNotEmpty && phoneC.text.isNotEmpty) {
      if (GetUtils.isPhoneNumber(phoneC.text)) {
        try {
          /// EKSEKUSI UPDATE
          /// MENGAMBIL UID USER
          String uid = auth.currentUser!.uid;

          /// MENYIAPKAN DATA MAPPING UNTUK PROSES UPDATE
          Map<String, dynamic> updateData = {
            "name": nameC.text,
            "phone": phoneC.text,
          };

          /// MENGECEK IMAGE APAKAH TIDAK NULL
          /// JIKA NULL , TIDAK MELAKUKAN APA APA
          if (image != null) {
            /// UPDATE FOTO
            /// MENAMBAHKAN PADA FIREABASE STORAGE DAN CLOUD FIRESTORE
            File file = File(image!.path);
            String ext = image!.name.split(".").last;

            print("MEMASUKAN FOTO KE FIREABASE STORAGE");
            await storage.ref('$uid/profile.$ext').putFile(file);

            String urlImage =
                await storage.ref("$uid/profile.$ext").getDownloadURL();

            /// SETELAH MENDAPATKAN URL
            /// KITA MASUKAN KE updateData LALU KE CLOUD FIRESTORE
            updateData.addAll(
              {
                "profile": urlImage,
              },
            );
          }

          // /// CEK ISI MAPPING
          // print("CEK ISI MAPPING : ${updateData}");

          /// MENGUPDATE  DATA USER DAN FOTO PROFILE
          await firestore.collection('users').doc(uid).update(updateData);

          /// SELANJUTNYA CEK PASSWORD
          if (passC.text.isNotEmpty) {
            /// JIKA PASSWORD TIDAK KOSONG
            if (passC.text.length > 6) {
              /// PASSWORD LEBIH DARI 6 -> EKSEKUSI
              await auth.currentUser!.updatePassword(passC.text);

              await auth.signOut();
              Get.offAllNamed(Routes.LOGIN);
              Get.snackbar(
                "Berhasil",
                "Berhasil mengupdate Password.",
              );
            } else {
              /// PASSWORD KURANG DARI 6
              Get.snackbar(
                "Terjadi Kesalahan",
                "Password Harus lebih dari 6",
                duration: Duration(seconds: 2),
              );
            }
          } else {
            /// JIKA PASSWORD KOSONG
            /// ARTINYA TIDAK MELAKUKAN PERUBAHAN PADA PASSWORD
            /// HANYA MELAKUKAN UPDATE DATA ATAU SEKALIAN UPDATE FOTO SAJA
            Get.back();
            Get.snackbar(
              "Berhasil",
              "Berhasil mengupdate profile.",
              duration: Duration(seconds: 2),
            );
          }

          ///
        } catch (e) {
          printError(info: e.toString(), logFunction: GetUtils.printFunction);
          Get.snackbar(
            "Terjadi Kesalahan",
            "Tidak dapat mengupdate profile. $e",
          );
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Nomor yang dimasukan bukan nomor telfon atau handhone",
        );
      }
    } else {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak Form Tidak Boleh Kosong",
      );
    }
  }

  /// ============ IMAGE PICKER ============
  final ImagePicker picker = ImagePicker();
  XFile? image;
  void pickImage() async {
    try {
      image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        print(image!.name);
        print(image!.name.split(".").last); // mengambil ekstention file Foto
        print(image!.path);
      } else {
        print(image);
      }
    } catch (e) {
      printError(info: e.toString(), logFunction: GetUtils.printFunction);
    }
    update();
  }

  /// ============ DELETE FOTO PROFLIE ============
  void deleteProfile({required String uid}) async {
    try {
      await firestore.collection("users").doc(uid).update(
        {
          "profile": FieldValue.delete(),
        },
      );

      /// KEMBALI KE PROFILE
      Get.back();

      /// SUKSES
      Get.snackbar(
        "Berhasil",
        "Berhasil menghapus foto profile.",
      );
    } catch (e) {
      print(e.toString());

      /// TERJADI ERROR
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak dapat menghapus foto profile. Hubungi admin",
      );
    } finally {
      update();
    }
  }
}

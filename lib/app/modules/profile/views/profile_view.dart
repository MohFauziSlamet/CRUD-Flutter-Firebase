import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          /// UNTUK LOGOUT
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                  title: "Halo",
                  middleText: "Apakah kamu ingin keluar ?",
                  textConfirm: "IYA",
                  onConfirm: () async {
                    await controller.logout();
                  });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getDataUser(),
          builder: (context, snapshot) {
            /// KETIKA WAITING , MENUGGU PROSES AMBIL DATA
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            /// KETIKA TERJADI ERROR
            /// DATA NULL
            if (snapshot.data == null) {
              return const Center(
                child: Text(
                  "Tidak dapat mengambil data user",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            }

            /// MEMASUKAN DATA YANG BARU DIDAPAT
            /// KEDALAM TextField
            Map<String, dynamic>? dataUser = snapshot.data;
            controller.nameC.text = dataUser!['name'];
            controller.phoneC.text = dataUser['phone'];
            controller.emailC.text = dataUser['email'];
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                /// TEXT INPUT NAMA
                TextField(
                  autocorrect: false,
                  controller: controller.nameC,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Nama"),
                  ),
                ),
                const SizedBox(height: 20),

                /// TEXT INPUT NOMOR TELFON
                TextField(
                  autocorrect: false,
                  controller: controller.phoneC,
                  textInputAction: TextInputAction.next,
                  obscureText: controller.isHidden.value,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Nomor Telfon"),
                  ),
                ),
                const SizedBox(height: 20),

                /// TEXT INPUT EMAIL
                TextField(
                  autocorrect: false,
                  readOnly: true,
                  controller: controller.emailC,
                  textInputAction: TextInputAction.next,
                  obscureText: controller.isHidden.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Email"),
                  ),
                ),

                /// TextField PASSWORD
                const SizedBox(height: 20),
                Obx(
                  () => TextField(
                    autocorrect: false,
                    controller: controller.passC,
                    textInputAction: TextInputAction.next,
                    obscureText: controller.isHidden.value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.isHidden.toggle();
                        },
                        icon: controller.isHidden.isFalse
                            ? const Icon(Icons.remove_red_eye_outlined)
                            : const Icon(Icons.remove_red_eye),
                      ),
                      label: const Text("New Password"),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// CREATED AT
                const Text("Created At : "),
                const SizedBox(height: 5),
                Text(
                  DateFormat.yMMMMEEEEd().add_Hms().format(
                        DateTime.parse(
                          snapshot.data!['createdAt'],
                        ),
                      ),
                ),
                const SizedBox(height: 20),

                /// MENGAMBIL FOTO PROFILE
                Text(
                  "Foto Profile",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<ProfileController>(
                      builder: (c) {
                        if (c.image != null) {
                          /// MENAMPILKAN IMAGE YANG BARUSAN DIPILIH
                          return ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.file(
                                File(c.image!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          if (dataUser["profile"] != null &&
                              dataUser["profile"] != "") {
                            /// MENAMPILKAN IMAGE YANG SUDAH ADA SEBELUMNYA
                            return Column(
                              children: [
                                ClipOval(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      dataUser['profile'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                /// TEXTBUTTON DELETE
                                TextButton(
                                  onPressed: () {
                                    controller.deleteProfile(
                                        uid: dataUser['uid']);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          } else {
                            /// JIKA KOSONG SEMUA
                            /// c.image kosong
                            /// dan database_firebase kosong
                            return Text("No Image");
                          }
                        }
                      },
                    ),

                    /// TEXTBUTTON CHOOSE IMAGE
                    TextButton(
                      onPressed: () {
                        controller.pickImage();
                      },
                      child: Text("choose image"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// BUTTON UPDATE
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      if (controller.isLoading.isFalse) {
                        controller.updateProfile();
                      }
                    },
                    child: Text(controller.isLoading.isFalse
                        ? "UPDATE PROFILE"
                        : "LOADING..."),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_firebase/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamProfile(),
              builder: (context, snapshot) {
                /// KETIKA WAITING , MENUGGU PROSES AMBIL DATA
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey[300],
                  );
                }

                Map<String, dynamic>? data = snapshot.data!.data();
                print(data?['name']);
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.PROFILE);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(data?["profile"] != null
                        ? data!["profile"]
                        : "https://ui-avatars.com/api/?name=${data?['name']}"),
                  ),
                );
              }),
          const SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamNote(),
          builder: (context, snapshot) {
            /// KETIKA WAITING , MENUGGU PROSES AMBIL DATA
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            /// KETIKA TERJADI ERROR
            /// DATA NULL
            if (snapshot.data == null && snapshot.data?.docs.length == 0) {
              return const Center(
                child: Text(
                  "Tidak ada data note",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                var uid = data.id;

                var dataNote = data.data();

                return ListTile(
                  onTap: () {
                    Get.toNamed(Routes.EDIT_NOTE, arguments: data);
                  },
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text("${dataNote['title']}"),
                  subtitle: Text("${dataNote['desc']}"),
                  trailing: IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                          title: "Halo",
                          middleText: "Apakah kamu ingn menghapus ini ?",
                          onCancel: () => Get.back(),
                          textCancel: "Batal",
                          textConfirm: "Iya",
                          onConfirm: () {
                            controller.deleteNote(id: uid);
                            Get.back();
                            Get.snackbar(
                              "Berhasil",
                              "Berhasil menghapus note",
                              duration: const Duration(seconds: 2),
                            );
                          });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );
          }),

      /// BUTTON ADD
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_NOTE);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

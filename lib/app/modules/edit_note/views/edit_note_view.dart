import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_note_controller.dart';

class EditNoteView extends GetView<EditNoteController> {
  EditNoteView({Key? key}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.titleC.text = data["title"];
    controller.descC.text = data["desc"];
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// TEXT INPUT TITLE
          TextField(
            autocorrect: false,
            controller: controller.titleC,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Title"),
            ),
          ),
          const SizedBox(height: 20),

          /// TEXT INPUT DESCRIPTION
          TextField(
            autocorrect: false,
            controller: controller.descC,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Description"),
            ),
          ),

          const SizedBox(height: 20),

          /// BUTTON UPDATE
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.editNote(id: data.id);
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? "EDIT NOTE" : "LOADING..."),
            ),
          ),
        ],
      ),
    );
  }
}

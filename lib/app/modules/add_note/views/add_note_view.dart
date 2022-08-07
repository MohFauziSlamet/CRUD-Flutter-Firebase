import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_note_controller.dart';

class AddNoteView extends GetView<AddNoteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddNoteView'),
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
                  controller.addNote();
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? "ADD NOTE" : "LOADING..."),
            ),
          ),
        ],
      ),
    );
  }
}

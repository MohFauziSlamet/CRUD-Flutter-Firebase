import 'package:database_firebase/app/modules/register/views/widget/required_warning.dart';
import 'package:database_firebase/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const RequiredWarning(),
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
          const RequiredWarning(),
          TextField(
            autocorrect: false,
            controller: controller.phoneC,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Phone"),
            ),
          ),
          const SizedBox(height: 20),
          const RequiredWarning(),
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
            ),
          ),
          const SizedBox(height: 20),
          const RequiredWarning(),
          Obx(
            () => TextField(
              autocorrect: false,
              controller: controller.passC,
              textInputAction: TextInputAction.done,
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
                label: const Text("Password"),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.register();
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? "REGISTER" : "LOADING..."),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Sudah punya akun ?"),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

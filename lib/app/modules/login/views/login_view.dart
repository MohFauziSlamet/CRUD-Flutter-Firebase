import 'package:database_firebase/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    if (box.read("rememberme") != null) {
      controller.emailC.text = box.read("rememberme")['email'];
      controller.passC.text = box.read("rememberme")['pass'];
      controller.rememberMe.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
            ),
          ),
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
                label: const Text("Password"),
              ),
            ),
          ),
          Obx(
            () => CheckboxListTile(
              value: controller.rememberMe.value,
              onChanged: (_) {
                controller.rememberMe.toggle();
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Rember Me"),
                  SizedBox(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.RESET_PASSWORD);
                          },
                          child: const Text("Reset Password ?"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.login();
                }
              },
              child:
                  Text(controller.isLoading.isFalse ? "LOGIN" : "LOADING..."),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Belum punya akun ?"),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.REGISTER);
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

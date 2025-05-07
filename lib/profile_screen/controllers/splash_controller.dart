import 'dart:developer';
import 'package:bakeryadminapp/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get obj => Get.find();

  UserModel? userModel;

  void getuser(String id) {
    FirebaseFirestore.instance.collection("admins").doc(id).get().then((value) {
      if (value.data() != null) {
        userModel = UserModel.fromMap(value.data()!);
        log("get user ${userModel}");
      } else {
        log(" not get user");
      }
    });
  }
}

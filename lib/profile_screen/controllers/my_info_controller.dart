
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyInfoController extends GetxController{
  static MyInfoController get obj=>Get.find();
  bool iconclicked = false;
  bool isclicked = false;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController paymentcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();

 void updatevalues({
  required String email,
  required String name,
  required String password,
  required String payment,
  required String address,
  required bool allownotification,

 }) async{
  await FirebaseFirestore.instance.collection("user").update(email:'email', name:'name' ,password:'password');
 
 }
}

extension on CollectionReference<Map<String, dynamic>> {
  update({required String email, required String name, required String password}) {}
}


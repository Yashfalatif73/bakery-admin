// import 'package:bakeryadminapp/HomeScreens/imagemodel.dart';
// import 'package:bakeryadminapp/HomeScreens/itemlisting.dart';
// import 'package:bakeryadminapp/models/usermodel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class AddItemController extends GetxController {
//   static AddItemController get obj => Get.find();

//   bool isclicked = false;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController desController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController categoryController = TextEditingController();

// //save function
//   void savefunction(userModel) {
//     if (nameController.text.isNotEmpty &&
//         desController.text.isNotEmpty &&
//         priceController.text.isNotEmpty &&
//         categoryController.text.isNotEmpty &&
//         isclicked.toString().isNotEmpty) {
//       update(['saveFunctionID']);
//     }
//   }

// //add item to firebase
//   void additem(UserModel model, BuildContext context) async {
//     FirebaseFirestore.instance
//         .collection("additem")
//         .doc(model.id)
//         .set(model.toMap());
//     Get.to(() => ItemListingScreen());
//   }

//   XFile? image;
//   // Use RxList to make the list observable
//   var imagesList = <ImageModel>[].obs;

//   Future<void> uploadImages() async {
//     final ImagePicker picker = ImagePicker();

//     // Allow the user to pick multiple images
//     List<XFile>? pickedImages = await picker.pickMultiImage();

//     if (pickedImages != null && pickedImages.isNotEmpty) {
//       for (var image in pickedImages) {
//         // Create an ImageModel for each selected image
//         ImageModel imageModel = ImageModel(
//           name: image.name,
//           path: image.path,
//         );

//         String simulatedUrl = await simulateUpload(imageModel);

//         // Update the image model with the simulated URL using copyWith
//         imageModel = imageModel.copyWith(url: simulatedUrl);

//         // Add the updated image model to the list
//         imagesList.add(imageModel);
//       }

//       // Print the list of images with their simulated URLs
//       for (var img in imagesList) {
//         print('Image Name: ${img.name}, URL: ${img.url}');
//       }
//     }
//   }

//   void deleteImage(int index) {
//     if (index >= 0 && index < imagesList.length) {
//       imagesList.removeAt(index); // Remove the image at the specified index
//     }
//   }

//   // Simulate the upload process
//   Future<String> simulateUpload(ImageModel imageModel) async {
//     // Simulate a delay to mimic network latency
//     await Future.delayed(Duration(seconds: 2));

//     // Return a dummy URL
//     return 'https://dummyurl.com/${imageModel.name}';
//   }
// }

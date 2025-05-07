import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bakeryadminapp/bottom_bar/bottom_bar.dart';

class RegisterBakery extends StatefulWidget {
  const RegisterBakery({super.key});

  @override
  State<RegisterBakery> createState() => _RegisterBakeryState();
}

class _RegisterBakeryState extends State<RegisterBakery> {
  final _bakeryNameController = TextEditingController();
  final _bakeryDescriptionController = TextEditingController();
  final _bakeryLocationController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  
  TimeOfDay _openingTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 20, minute: 0);
  String _bakeryTiming = "09:00 - 20:00";
  
  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  
  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
  
  Future<void> _selectOpeningTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _openingTime,
    );
    
    if (picked != null) {
      setState(() {
        _openingTime = picked;
        _bakeryTiming = "${_formatTimeOfDay(_openingTime)} - ${_formatTimeOfDay(_closingTime)}";
      });
    }
  }
  
  Future<void> _selectClosingTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _closingTime,
    );
    
    if (picked != null) {
      setState(() {
        _closingTime = picked;
        _bakeryTiming = "${_formatTimeOfDay(_openingTime)} - ${_formatTimeOfDay(_closingTime)}";
      });
    }
  }
  
  bool _validateLatLng() {
    if (_latitudeController.text.isEmpty || _longitudeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both latitude and longitude')),
      );
      return false;
    }
    
    try {
      double lat = double.parse(_latitudeController.text);
      double lng = double.parse(_longitudeController.text);
      
      if (lat < -90 || lat > 90) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Latitude must be between -90 and 90')),
        );
        return false;
      }
      
      if (lng < -180 || lng > 180) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Longitude must be between -180 and 180')),
        );
        return false;
      }
      
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numeric values for latitude and longitude')),
      );
      return false;
    }
  }
  
  Future<void> _uploadImageAndSaveBakeryInfo() async {
    if (_bakeryNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter bakery name')),
      );
      return;
    }
    
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bakery image')),
      );
      return;
    }
    
    if (_bakeryLocationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter bakery location')),
      );
      return;
    }
    
    if (!_validateLatLng()) {
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }
      
      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('bakery_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      
      // Prepare the LatLng string
      String bakeryLatLng = "${_latitudeController.text},${_longitudeController.text}";
      
      // Update user document with bakery information
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .update({
        'bakeryName': _bakeryNameController.text.trim(),
        'bakeryDescription': _bakeryDescriptionController.text.trim(),
        'bakeryTiming': _bakeryTiming,
        'bakeryImage': downloadUrl,
        'bakeryLocation': _bakeryLocationController.text.trim(),
        'bakeryLatLng': bakeryLatLng,
        'bakeryRating': 0,
      });
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomBarScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error registering bakery: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Your Bakery'),
        centerTitle: true,
        backgroundColor: const Color(0xffEEEEE6),
      ),
      backgroundColor: const Color(0xffEEEEE6),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Bakery Name"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bakeryNameController,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 20),
                
                const Text("Bakery Description"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bakeryDescriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 20),
                
                const Text("Bakery Timing"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectOpeningTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(_formatTimeOfDay(_openingTime)),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("to"),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: _selectClosingTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(_formatTimeOfDay(_closingTime)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                const Text("Bakery Thumbnail Photo"),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                                SizedBox(height: 5),
                                Text("Tap to select image", style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text("Bakery Location"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bakeryLocationController,
                  decoration: _inputDecoration(hintText: "Enter full address of your bakery"),
                ),
                const SizedBox(height: 20),
                
                const Text("Enter your bakery's latitude and longitude"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latitudeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: _inputDecoration(hintText: "Latitude (e.g., 37.7749)"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _longitudeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: _inputDecoration(hintText: "Longitude (e.g., -122.4194)"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _uploadImageAndSaveBakeryInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register Bakery", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }
}
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parking_v3/src/common_widget/my_bottom.dart';
import 'package:parking_v3/src/common_widget/my_text_field.dart';
import 'package:parking_v3/src/constants/routes.dart';
import 'package:parking_v3/src/features/auth/application/auth_service.dart';
import 'package:parking_v3/src/features/profile/domain/profile.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  File? imageFile;
  String? imagePath;
  Timestamp? createAt;
  Timestamp? updateAt;

  void signUp() async {
    if (passwordConfirmed()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content:
                const Text("Are you sure you want to create a new account?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                ),
              ),
              TextButton(
                onPressed: () async {
                  final authService =
                      Provider.of<AuthService>(context, listen: false);

                  imagePath = await uploadFile();

                  try {
                    Profile profile = Profile(
                      name: nameController.text,
                      email: emailController.text,
                      address: addressController.text,
                      number: numberController.text,
                      image: imagePath!,
                      createdAt: Timestamp.now(),
                      updatedAt: Timestamp.now(),
                    );

                    await authService.signUpWithEmailAndPassword(
                      profile,
                      passwordController.text,
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(
                      context,
                      authGate,
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text(
                  "Create a new account",
                ),
              ),
            ],
          );
        },
      );
    }
  }

  bool passwordConfirmed() {
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // check that the passwords do not match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password do not match!",
          ),
        ),
      );
      return false;
    }

    // Make sure the password doesn't meet the requirements
    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password must be at least 8 characters long and contain at least have upper case letters, lower case letters, and have numbers",
          ),
        ),
      );

      return false;
    }

    return true;
  }

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
        // imgName = basename
      });
    }
  }

  Future<String> uploadFile() async {
    try {
      final imageName =
          "${DateTime.now().microsecondsSinceEpoch.toString()}-${imageFile!.path.split(Platform.pathSeparator).last}";
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDireImages = referenceRoot.child('images/users');
      Reference referenceImageToUpload = referenceDireImages.child(imageName);
      final metadata = SettableMetadata(contentType: "image/jpeg");

      final uploadTask =
          referenceImageToUpload.putFile(File(imageFile!.path), metadata);

      await uploadTask; // Wait for the upload to complete

      final imageUrl = await referenceImageToUpload.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF7F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // profile image
                  InkWell(
                    borderRadius: BorderRadius.circular(60),
                    onTap: () {
                      _openImagePicker();
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: imageFile == null
                            ? Border.all(
                                color: Colors.black45,
                                style: BorderStyle.solid,
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: imageFile == null
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    size: 40.0,
                                    color: Colors.black54,
                                  ),
                                  Gap(2.0),
                                  Text(
                                    'Select Image',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(
                                imageFile!,
                                height: 120.0,
                                width: 120.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const Gap(50),

                  // name text field
                  MyTextField(
                    controller: nameController,
                    hintText: "Full Name",
                    obscureText: false,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(10),

                  // email text field
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Gap(10),

                  // address text field
                  MyTextField(
                    controller: addressController,
                    hintText: "address",
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  const Gap(10),

                  // number text field
                  MyTextField(
                    controller: numberController,
                    hintText: "Phone Number",
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const Gap(10),

                  // password text field
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  const Gap(10),

                  // confirm password text field
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Rewrite password",
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  const Gap(10),

                  // sign up button
                  MyButton(
                    onTap: signUp,
                    text: "sign Up",
                  ),
                  const Gap(50),

                  // Already a member ? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member ?"),
                      const Gap(4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

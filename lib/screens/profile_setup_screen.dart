import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? image;
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  bool isLoading = false;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.userModel.name);
    usernameController = TextEditingController(text: widget.userModel.username);
    emailController = TextEditingController(text: widget.userModel.email);
    super.initState();
  }

  getImage() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        image = file.path;
      });
    }
  }

  saveNewDetail() async {
    setState(() {
      isLoading = true;
    });
    final user = widget.userModel.copyWith(
      name: nameController.text.trim(),
      username: usernameController.text.trim(),
      imageUrl: image ?? widget.userModel.imageUrl,
    );
    await FirestoreService().editUserDetails(user).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    Fluttertoast.showToast(msg: 'Actualización de perfil exitosa');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.amber.shade300,
            Colors.amber.shade100,
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Configuración de perfil'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: image == null && widget.userModel.imageUrl == null
                      ? null
                      : image == null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                  widget.userModel.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: FileImage(File(image!)),
                              fit: BoxFit.cover,
                            ),
                ),
                child: Stack(
                  children: [
                    image == null && widget.userModel.imageUrl == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: const Image(
                              image: AssetImage('assets/images/author.png'),
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : const SizedBox(width: 0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () => getImage(),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            EditTextField(
              label: 'Nombre',
              text: widget.userModel.name,
              onChanged: (v) {},
              controller: nameController,
            ),
            const SizedBox(height: 15),
            EditTextField(
              label: 'Nombre de usuario',
              text: widget.userModel.name,
              onChanged: (v) {},
              controller: usernameController,
            ),
            const SizedBox(height: 15),
            EditTextField(
              label: 'Correo electrónico',
              text: widget.userModel.name,
              onChanged: (v) {},
              isEnabled: false,
              controller: emailController,
            ),
            const SizedBox(height: 15),
            MyButton(
              onTap: () => saveNewDetail(),
              text: 'Ahorrar',
              isLoading: isLoading,
            )
          ],
        ),
      ),
    );
  }
}

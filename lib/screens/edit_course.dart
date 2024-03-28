import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/screens/home_screen.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class EditCourse extends StatefulWidget {
  const EditCourse({super.key, required this.courseModel});
  final CourseModel courseModel;

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  String? image;

  FirestoreService firestoreService = FirestoreService();

  init() {
    titleController = TextEditingController(text: widget.courseModel.title);
    subtitleController =
        TextEditingController(text: widget.courseModel.subtitle);
    descriptionController =
        TextEditingController(text: widget.courseModel.description);
    priceController = TextEditingController(text: widget.courseModel.price);
  }

  @override
  initState() {
    super.initState();
    init();
  }

  _getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage.path;
      });
    }
  }

  bool isLoading = false;

  _uploadCourse() async {
    setState(() {
      isLoading = true;
    });
    final courseModel = CourseModel(
      description: descriptionController.text.trim(),
      title: titleController.text.trim(),
      subtitle: subtitleController.text.trim(),
      price: priceController.text.trim(),
      id: widget.courseModel.id,
      image: image ?? widget.courseModel.image,
    );
    await firestoreService.editCourse(courseModel).whenComplete(() {
      Fluttertoast.showToast(msg: 'Carga del curso exitosamente');
    });
    setState(() {
      isLoading = false;
    });
    Get.offAll(() => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar curso'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _getImage(),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: image == null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(
                              widget.courseModel.image,
                            ),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: FileImage(
                              File(image!),
                            ),
                            fit: BoxFit.cover,
                          ),
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Título del curso',
                text: '',
                onChanged: (c) {},
                controller: titleController,
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Subtítulo del curso',
                text: '',
                onChanged: (c) {},
                controller: subtitleController,
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Descripción del curso',
                text: '',
                onChanged: (c) {},
                controller: descriptionController,
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Precio del curso',
                text: '',
                onChanged: (c) {},
                controller: priceController,
              ),
              const SizedBox(height: 15),
              MyButton(
                onTap: () => _uploadCourse(),
                text: 'Ahorrar',
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

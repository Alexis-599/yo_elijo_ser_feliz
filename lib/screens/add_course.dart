import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/edit_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? image;

  FirestoreService firestoreService = FirestoreService();

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

  _clearScreen() {
    setState(() {
      titleController.clear();
      subtitleController.clear();
      descriptionController.clear();
      priceController.clear();
      image = null;
      isLoading = false;
    });
  }

  _uploadCourse() async {
    setState(() {
      isLoading = true;
    });
    final courseModel = CourseModel(
      description: descriptionController.text.trim(),
      title: titleController.text.trim(),
      subtitle: subtitleController.text.trim(),
      price: priceController.text.trim(),
      id: '',
      image: image!,
    );
    await firestoreService.postNewCourse(courseModel).whenComplete(() {
      _clearScreen();
      Fluttertoast.showToast(msg: 'Course upload successfully');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Courses'),
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
                    border: Border.all(
                      color: Colors.black12,
                      width: 3,
                    ),
                    image: image == null
                        ? null
                        : DecorationImage(
                            image: FileImage(
                              File(image!),
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: image == null
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
                ),
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Course title',
                text: '',
                onChanged: (c) {},
                controller: titleController,
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Course subtitle',
                text: '',
                onChanged: (c) {},
                controller: subtitleController,
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Course description',
                text: '',
                onChanged: (c) {},
                controller: descriptionController,
              ),
              const SizedBox(height: 15),
              EditTextField(
                label: 'Course price',
                text: '',
                onChanged: (c) {},
                controller: priceController,
              ),
              const SizedBox(height: 15),
              MyButton(
                onTap: () => _uploadCourse(),
                text: 'Add Course',
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

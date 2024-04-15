import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/screens/checkout_screen.dart';
import 'package:podcasts_ruben/screens/edit_course.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/alert_dialog.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';
import 'package:provider/provider.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.courseModel});
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserModel?>();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade400.withOpacity(1),
            Colors.blue.shade900.withOpacity(1),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Detalle del cursos',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            if (currentUser != null && currentUser.isAdmin)
              PopupMenuButton(
                itemBuilder: (c) {
                  return [
                    PopupMenuItem(
                      child: const Text('Editar detalles del curso'),
                      onTap: () => Get.to(
                        () => EditCourse(courseModel: courseModel),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text(
                        'Eliminar curso',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => CustomAdaptiveAlertDialog(
                            alertMsg:
                                '¿Estás seguro de que deseas eliminar este curso?',
                            actiionBtnName: 'Sí',
                            onAction: () async {
                              await FirestoreService()
                                  .deleteCourse(courseModel.id)
                                  .whenComplete(() {
                                Get.back();
                                Get.back();
                                Fluttertoast.showToast(
                                  msg: 'Curso eliminado exitosamente',
                                );
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ];
                },
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                      image: CachedNetworkImageProvider(courseModel.image),
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "\$MXN${courseModel.price}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    courseModel.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    courseModel.subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    courseModel.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 0,
                child: currentUser == null
                    ? MyButton(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg:
                                  'Necesitas iniciar sesión antes de comprar el curso.');
                        },
                        text: "Comprar curso para \$MXN${courseModel.price}",
                        isLoading: false,
                      )
                    : MyButton(
                        onTap: () {
                          currentUser.coursesIds!.contains(courseModel.id)
                              ? Fluttertoast.showToast(msg: 'Comprado')
                              : Get.to(() => CheckoutScreen(
                                    courseModel: courseModel,
                                  ));
                        },
                        text: "Comprar curso para \$MXN${courseModel.price}",
                        isLoading: false,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

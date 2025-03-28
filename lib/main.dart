import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_app_task_enterslice/models/location_model.dart';
import 'package:flutter_app_task_enterslice/viewmodels/location_viewmodel.dart';
import 'package:flutter_app_task_enterslice/views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Location Tracker ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeView(),
      initialBinding: BindingsBuilder(() {
        Get.put(LocationViewModel());
      }),
    );
  }
}

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_app_task_enterslice/models/location_model.dart';

class LocationViewModel extends GetxController {
  static const platform = MethodChannel(
    'com.example.flutter_app_task_enterslice/location',
  );

  final Rx<LocationModel> currentLocation = LocationModel().obs;
  final RxList<LocationModel> locationHistory = <LocationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    try {
      final locationStatus = await Permission.location.request();

      //required for new devices
      final notificationStatus = await Permission.notification.request();

     // print(locationStatus);
      if (locationStatus.isGranted) {
        await startLocationService();
        await getLastLocation();
      } else {
        hasError.value = true;
        errorMessage.value = 'Location permission denied';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to request permissions: $e';
    }
  }

  Future<void> startLocationService() async {
    try {
      await platform.invokeMethod('startLocationService');
    } on PlatformException catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to start location service: ${e.message}';
    }
  }

  Future<void> getLastLocation() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final Map<dynamic, dynamic>? result = await platform.invokeMethod(
        'getLastLocation',
      );

      if (result != null && result.isNotEmpty) {
        currentLocation.value = LocationModel.fromMap(
          Map<String, dynamic>.from(result),
        );
      }
      await getLocationHistory();
    } on PlatformException catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to get location: ${e.message}';
    } finally {
      isLoading.value = false;
    }
  }

  // see location history
  Future<void> getLocationHistory() async {
    try {
      final List<dynamic>? results = await platform.invokeMethod(
        'getLocationHistory',
      );

      if (results != null && results.isNotEmpty) {
        locationHistory.clear();

        for (var item in results) {
          final Map<String, dynamic> location = Map<String, dynamic>.from(item);
          locationHistory.add(LocationModel.fromMap(location));
        }
      }
    } on PlatformException catch (e) {
      print('Failed to get location history: ${e.message}');
    }
  }

  
  // fetch location every min
  Future<void> startPeriodicUpdates() async {
    Timer.periodic(const Duration(seconds: 60), (timer) async {
      await getLastLocation();
    });
  }


//formate the location and time data
  String get formattedLocation {
    if (!currentLocation.value.hasValidCoordinates) {
      return 'Location not available';
    }

    final lat = currentLocation.value.latitude?.toStringAsFixed(6);
    final lng = currentLocation.value.longitude?.toStringAsFixed(6);
    return 'Latitude: $lat, \n Longitude: $lng';
  }

  // locationstr != null
  //                         ? DateFormat(
  //                           'MMM dd, yyyy - hh:mm aa',
  //                         ).format(locationstr!)
  //                         : 'Unknown time',

  String get lastUpdatedTime {
    if (currentLocation.value.timestamp == null) {
      return 'Never updated';
    }
    String formattedTime =
        currentLocation.value.timestamp != null
            ? DateFormat(
              'MMM dd, yyyy - hh:mm aa',
            ).format(currentLocation.value.timestamp!)
            : 'Unknown time';

    return 'Last updated: ${formattedTime}';
  }
}

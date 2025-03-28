import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_app_task_enterslice/viewmodels/location_viewmodel.dart';
import 'package:flutter_app_task_enterslice/views/location_history_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LocationViewModel _viewModel = Get.find<LocationViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.startPeriodicUpdates();
  }

  @override
  Widget build(BuildContext context) {
    print(_viewModel.formattedLocation);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (_viewModel.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    _viewModel.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 24),
                  //  TextButton(
                  //   onPressed: () => _viewModel.getLastLocation(),
                  //   child: const Text('Refresh'),
                  // ),
                  ElevatedButton(
                    onPressed: () => _viewModel.getLastLocation(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 80, color: Colors.blue),
                const SizedBox(height: 24),
                const Text(
                  'Current Location',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _viewModel.formattedLocation,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        //locationstr != null
                        // ? DateFormat(
                        //   'MMM dd, yyyy - HH:mm:ss',
                        // ).format(location.timestamp!)
                        // : 'Unknown time',
                        Text(
                          _viewModel.lastUpdatedTime,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _viewModel.getLastLocation(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                    const SizedBox(width: 16),

                    ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const LocationHistoryView());
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: Colors.red),
                      ),
                      icon: const Icon(Icons.history, color: Colors.red),
                      label: const Text(
                        'View History',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app_task_enterslice/models/location_model.dart';
import 'package:flutter_app_task_enterslice/viewmodels/location_viewmodel.dart';

class LocationHistoryView extends StatelessWidget {
  const LocationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationViewModel viewModel = Get.find<LocationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Obx(() {
        if (viewModel.locationHistory.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No data available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.getLocationHistory(),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: viewModel.locationHistory.length,
            itemBuilder: (context, index) {
              final LocationModel location = viewModel.locationHistory[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.location_on, color: Colors.white),
                  ),
                  title: Text(
                    'Lat: ${location.latitude?.toStringAsFixed(6) ?? "N/A"}, \n'
                    'Lng: ${location.longitude?.toStringAsFixed(6) ?? "N/A"}',
                  ),
                  subtitle: Text(
                    location.timestamp != null
                        ? DateFormat(
                          'MMM dd, yyyy - hh:mm aa',
                        ).format(location.timestamp!)
                        : 'Unknown time',
                  ),
                  //trailing: const Icon(Icons.info),
                  // onTap: () {

                  // },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.getLocationHistory(),
        tooltip: 'Refresh',
        backgroundColor: Colors.red,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  // void _showLocationDetails(BuildContext context, LocationModel location) {
  //print(location);
  // }
}

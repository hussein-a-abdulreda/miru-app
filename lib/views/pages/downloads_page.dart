import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:get/get.dart';
import 'package:miru_app/controllers/download_manager_controller.dart';
import 'package:miru_app/views/widgets/platform_widget.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  Widget _buildAndroid(BuildContext context) {
    final DownloadManagerController downloadManager = Get.find<DownloadManagerController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Manager'),
      ),
      body: Obx(() {
        if (downloadManager.tasks.isEmpty) {
          return const Center(
            child: Text(
              'No active or completed downloads',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: downloadManager.tasks.length,
          itemBuilder: (context, index) {
            final task = downloadManager.tasks[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.animeTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.episodeName,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    if (task.isCompleted)
                      const Text(
                        'Status: Completed',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      )
                    else if (task.isFailed)
                      const Text(
                        'Status: Failed',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(value: task.progress),
                          const SizedBox(height: 4),
                          Text('${(task.progress * 100).toStringAsFixed(1)}%'),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          downloadManager.cancelDownload(task);
                        },
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        label: const Text('Cancel / Remove', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final DownloadManagerController downloadManager = Get.find<DownloadManagerController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Download Manager',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (downloadManager.tasks.isEmpty) {
                return const Center(
                  child: Text(
                    'No active or completed downloads',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: downloadManager.tasks.length,
                itemBuilder: (context, index) {
                  final task = downloadManager.tasks[index];
                  return fluent.Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.animeTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.episodeName,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          if (task.isCompleted)
                            const Text(
                              'Status: Completed',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            )
                          else if (task.isFailed)
                            const Text(
                              'Status: Failed',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(value: task.progress),
                                const SizedBox(height: 4),
                                Text('${(task.progress * 100).toStringAsFixed(1)}%'),
                              ],
                            ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: fluent.Button(
                              onPressed: () {
                                downloadManager.cancelDownload(task);
                              },
                              child: const Text('Cancel / Remove', style: TextStyle(color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformBuildWidget(
      androidBuilder: _buildAndroid,
      desktopBuilder: _buildDesktop,
    );
  }
}
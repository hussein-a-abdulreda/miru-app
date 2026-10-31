import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DownloadTask {
  final String id;
  final String animeTitle;
  final String episodeName;
  final String savePath;
  final Map<String, dynamic>? headers;

  double progress = 0.0;
  bool isCompleted = false;
  bool isFailed = false;
  CancelToken cancelToken = CancelToken();

  DownloadTask({
    required this.id,
    required this.animeTitle,
    required this.episodeName,
    required this.savePath,
    this.headers,
  });
}

class DownloadManagerController extends GetxController {
  var tasks = <DownloadTask>[].obs;

  Future<void> enqueueDownload({
    required String animeTitle,
    required String episodeName,
    required String url,
    required String savePath,
    Map<String, dynamic>? headers,
  }) async {
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();
    final task = DownloadTask(
      id: taskId,
      animeTitle: animeTitle,
      episodeName: episodeName,
      savePath: savePath,
      headers: headers,
    );

    tasks.add(task);

    try {
      final dio = Dio();
      await dio.download(
        url,
        savePath,
        cancelToken: task.cancelToken,
        options: Options(
          headers: headers,
          followRedirects: true,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            task.progress = received / total;
          } else {
            task.progress = 0.0;
          }
          tasks.refresh();
        },
      );

      task.isCompleted = true;
      task.progress = 1.0;
      tasks.refresh();
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        print('Download cancelled for $episodeName');
      } else {
        task.isFailed = true;
        tasks.refresh();
        print('Download failed for $episodeName: $e');
      }
    }
  }

  void cancelDownload(DownloadTask task) async {
    task.cancelToken.cancel('Cancelled by user');
    tasks.remove(task);

    try {
      final file = File(task.savePath);
      if (await file.exists()) {
        await file.delete();
        print('Incomplete file deleted: ${task.savePath}');
      }
    } catch (e) {
      print('Failed to delete incomplete file: $e');
    }
  }
}
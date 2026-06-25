import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AudioHelper {
  static const _uuid = Uuid();

  static Future<String> getRecordingPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${dir.path}/recordings');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return '${audioDir.path}/${_uuid.v4()}.wav';
  }

  static Future<String> getTtsOutputPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${dir.path}/tts_output');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return '${audioDir.path}/${_uuid.v4()}.mp3';
  }

  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> cleanupOldFiles({int maxAgeInDays = 7}) async {
    final dir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${dir.path}/recordings');
    final ttsDir = Directory('${dir.path}/tts_output');

    for (final directory in [recordingsDir, ttsDir]) {
      if (await directory.exists()) {
        final cutoff =
            DateTime.now().subtract(Duration(days: maxAgeInDays));
        await for (final entity in directory.list()) {
          if (entity is File) {
            final stat = await entity.stat();
            if (stat.modified.isBefore(cutoff)) {
              await entity.delete();
            }
          }
        }
      }
    }
  }
}

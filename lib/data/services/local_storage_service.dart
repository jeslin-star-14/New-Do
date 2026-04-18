import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class LocalStorageService {
  static const String boxName = "tasksBox";

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>(boxName);
  }

  static Box<Task> getBox() {
    return Hive.box<Task>(boxName);
  }
}
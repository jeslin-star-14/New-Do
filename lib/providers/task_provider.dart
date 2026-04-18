import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/services/local_storage_service.dart';

class TaskProvider extends ChangeNotifier {
  final box = LocalStorageService.getBox();

  List<Task> get tasks => box.values.toList();

  void addTask(Task task) {
    box.add(task);
    notifyListeners();
  }

  void updateTask(int index, Task task) {
    box.putAt(index, task);
    notifyListeners();
  }

  void deleteTask(int index) {
    box.deleteAt(index);
    notifyListeners();
  }

  void toggleTask(int index) {
    final task = box.getAt(index);
    task!.isCompleted = !task.isCompleted;
    task.save();
    notifyListeners();
  }
}
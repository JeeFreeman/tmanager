import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tmanager/core/models/task_model.dart';
import 'package:tmanager/core/services/task_service.dart';
import 'package:uuid/uuid.dart';

String? getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  List<TaskModel> _filteredTasks = [];
  List<TaskModel> get filteredTasks => _filteredTasks;

  Future<void> loadTasks() async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    notifyListeners();

    _tasks = await _taskService.loadTasks(userId);
    _filteredTasks = _tasks;

    notifyListeners();
  }

  Future<void> saveTask(TaskModel task) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    if (task.id == null) {
      await addTask(task.title, task.description);
    } else {
      await _taskService.updateTask(userId, task);
    }
  }

  Future addTask(String title, String description) async {
    final userId = getCurrentUserId();
    if (userId != null) {
      final newTask = TaskModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
      );
      _tasks.add(newTask);
      await _taskService.addTask(userId, newTask);
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskModel task) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    final taskIndex = _tasks.indexWhere((e) => e.id == task.id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = task;
      await _taskService.updateTask(userId, task);
      notifyListeners();
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    _tasks.remove(task);
    _filteredTasks = _tasks;
    await _taskService.deleteTask(userId, task.id!);
    notifyListeners();
  }

  List<TaskModel> searchTasks(String query) {
    return _tasks
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void filterTasks(String query) {
    if (query.isEmpty) {
      _filteredTasks = _tasks;
    } else {
      _filteredTasks = _tasks.where((task) {
        return task.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  bool isTaskDuplicate(String title, String description) {
    return _tasks
        .any((task) => task.title == title || task.description == description);
  }
}

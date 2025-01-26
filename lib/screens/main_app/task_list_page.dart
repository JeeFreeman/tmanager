import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmanager/core/models/task_model.dart';
import 'package:tmanager/core/providers/task_provider.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  bool isGridView = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false)..loadTasks();
    searchController.addListener(() {
      taskProvider.filterTasks(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().filteredTasks;

    return Column(
      children: [
        ColoredBox(
          color: Colors.black,
          child: Column(
            children: [
              TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Поиск задачи',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.view_module, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isGridView = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.view_list, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isGridView = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Task List
        Expanded(
          child: isGridView
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => _showTaskOptions(context, index, tasks[index]),
                        child: Center(
                          child: Text(
                            tasks[index].title,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => _showTaskOptions(context, index, tasks[index]),
                      tileColor: Colors.white10,
                      title: Text(
                        tasks[index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.clear)),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showTaskOptions(BuildContext context, int index, TaskModel task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text('Переименовать', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showEditTaskDialog(context, task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.white),
              title: const Text('Удалить', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Provider.of<TaskProvider>(context, listen: false).deleteTask(task);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskModel task) {
    String updatedTitle = task.title;
    String updatedDescription = task.description;
    final titleController = TextEditingController(text: updatedTitle);
    final descriptionController = TextEditingController(text: updatedDescription);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text(
          'Переименовать задачу',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              onChanged: (value) => updatedTitle = value,
              decoration:
                  const InputDecoration(labelText: 'Название задачи', labelStyle: TextStyle(color: Colors.grey)),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: descriptionController,
              onChanged: (value) => updatedDescription = value,
              decoration:
                  const InputDecoration(labelText: 'Описание задачи', labelStyle: TextStyle(color: Colors.grey)),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).updateTask(task);
              Navigator.pop(context);
            },
            child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

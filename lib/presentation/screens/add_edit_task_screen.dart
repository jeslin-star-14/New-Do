import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../data/models/task_model.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  final int? index;

  const AddEditTaskScreen({super.key, this.task, this.index});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  DateTime? dueDate;
  int priority = 1;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descController.text = widget.task!.description ?? '';
      dueDate = widget.task!.dueDate;
      priority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<int>(
              initialValue: priority,
              decoration: const InputDecoration(labelText: "Priority"),
              items: const [
                DropdownMenuItem(value: 1, child: Text("Low")),
                DropdownMenuItem(value: 2, child: Text("Medium")),
                DropdownMenuItem(value: 3, child: Text("High")),
              ],
              onChanged: (value) {
                setState(() {
                  priority = value!;
                });
              },
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Text(
                    dueDate == null
                        ? "No due date selected"
                        : "Due: ${dueDate!.toLocal().toString().split(' ')[0]}",
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dueDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() {
                        dueDate = picked;
                      });
                    }
                  },
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final task = Task(
                    title: titleController.text,
                    description: descController.text,
                    dueDate: dueDate,
                    priority: priority,
                  );

                  if (widget.task == null) {
                    provider.addTask(task);
                  } else {
                    provider.updateTask(widget.index!, task);
                  }

                  Navigator.pop(context);
                },
                child: const Text("Save Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
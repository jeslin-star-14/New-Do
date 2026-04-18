import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filter = "all";
  String searchQuery = "";

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning ☀️";
    if (hour < 17) return "Good Afternoon 🌤️";
    return "Good Evening 🌙";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    final tasks = provider.tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(searchQuery.toLowerCase());

      if (filter == "completed") {
        return task.isCompleted && matchesSearch;
      } else if (filter == "active") {
        return !task.isCompleted && matchesSearch;
      }
      return matchesSearch;
    }).toList();

    final total = provider.tasks.length;
    final completed =
        provider.tasks.where((t) => t.isCompleted).length;
    final pending = total - completed;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                getGreeting(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Total", total, Colors.blue),
                  _buildStatCard("Done", completed, Colors.green),
                  _buildStatCard("Pending", pending, Colors.orange),
                ],
              ),

              const SizedBox(height: 15),

              
              TextField(
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              
              Row(
                children: [
                  _buildFilterChip("All", "all"),
                  _buildFilterChip("Active", "active"),
                  _buildFilterChip("Done", "completed"),
                ],
              ),

              const SizedBox(height: 10),

              
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          "No tasks found 🚀",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 300),
                            margin:
                                const EdgeInsets.only(bottom: 10),
                            child: TaskTile(
                              task: task,
                              onToggle: () {
                                final originalIndex =
                                    provider.tasks.indexOf(task);
                                provider.toggleTask(originalIndex);
                              },
                              onDelete: () {
                                final originalIndex =
                                    provider.tasks.indexOf(task);
                                provider.deleteTask(originalIndex);
                              },
                              onEdit: () {
                                final originalIndex =
                                    provider.tasks.indexOf(task);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddEditTaskScreen(
                                      task: task,
                                      index: originalIndex,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditTaskScreen(),
            ),
          );
        },
        label: const Text("Add Task"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  
  Widget _buildStatCard(String title, int value, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildFilterChip(String label, String value) {
    final isSelected = filter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            filter = value;
          });
        },
      ),
    );
  }
}

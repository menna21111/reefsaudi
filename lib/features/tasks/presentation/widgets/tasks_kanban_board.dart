import 'package:flutter/material.dart';
import '../../domain/models/task_board_mock_data.dart';
import '../../domain/models/task_item.dart';
import 'tasks_kanban_column.dart';

class TasksKanbanBoard extends StatelessWidget {
  final List<TaskItem> tasks;
  final ValueChanged<TaskItem> onTaskTap;

  const TasksKanbanBoard({
    super.key,
    required this.tasks,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: taskKanbanColumns.map((column) {
          final columnTasks =
              tasks.where((t) => t.status == column.key).toList();
          return TasksKanbanColumn(
            title: column.title,
            count: columnTasks.length,
            tasks: columnTasks,
            onTaskTap: onTaskTap,
          );
        }).toList(),
      ),
    );
  }
}

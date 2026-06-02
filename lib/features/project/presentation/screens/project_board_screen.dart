import 'package:flutter/material.dart';
import '../../../tasks/presentation/screens/tasks_screen.dart';

/// يفتح لوحة المهام من سياق المشروع (مع زر رجوع).
class ProjectBoardScreen extends StatelessWidget {
  const ProjectBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TasksScreen(showBackButton: true);
  }
}

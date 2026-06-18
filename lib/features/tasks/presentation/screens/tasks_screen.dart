import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/models/task_board_mock_data.dart';
import '../../domain/models/task_item.dart';
import '../widgets/tasks_board_app_bar.dart';
import '../widgets/tasks_change_status_sheet.dart';
import '../widgets/tasks_search_field.dart';
import '../widgets/tasks_task_card.dart';

/// شاشة المهام — قائمة بطاقات للموبايل (تبويب التنقل أو من تفاصيل المشروع).
class TasksScreen extends StatefulWidget {
  const TasksScreen({
    super.key,
    this.showBackButton = false,
    this.projectSubtitle = 'Sustainable Coastal Dev.',
  });

  final bool showBackButton;
  final String projectSubtitle;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late List<TaskItem> _tasks;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tasks = mockTaskItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<TaskItem> get _filteredTasks {
    if (_searchQuery.isEmpty) return _tasks;

    final query = _searchQuery.trim().toLowerCase();
    return _tasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
          task.category.toLowerCase().contains(query) ||
          task.owner.toLowerCase().contains(query) ||
          task.contractor.toLowerCase().contains(query) ||
          task.id.toLowerCase().contains(query);
    }).toList();
  }

  void _onTaskTap(TaskItem task) {
    TasksChangeStatusSheet.show(
      context,
      task: task,
      onStatusSelected: (status) {
        setState(() => task.status = status);
      },
    );
  }

  void _focusSearch() => _searchFocusNode.requestFocus();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tasks = _filteredTasks;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: TasksBoardAppBar(
        showBackButton: widget.showBackButton,
        projectSubtitle: widget.projectSubtitle,
        onSearchTap: _focusSearch,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
            child: TasksSearchField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      AppString.noData.tr(),
                      style: TextStyle(
                        color: colors.kGrayColor,
                        fontSize: 14.sp,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TasksTaskCard(
                        task: task,
                        onTap: () => _onTaskTap(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

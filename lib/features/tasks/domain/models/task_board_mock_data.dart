import '../../../../core/utils/app_color.dart';
import 'task_item.dart';

List<TaskItem> mockTaskItems() => [
      TaskItem(
        id: 'TSK-001',
        title: 'Structural Site Analysis Phase 1',
        owner: 'Omar A.',
        duration: '2 days',
        statusLabel: '2 days',
        status: 'new',
        indicatorColor: AppColor.kRedColor,
        badgeColor: AppColor.kRedColor.withOpacity(0.1),
        badgeTextColor: AppColor.kRedColor,
      ),
      TaskItem(
        id: 'TSK-002',
        title: 'Environmental Impact Survey',
        owner: 'Sarah K.',
        duration: '5 days',
        statusLabel: '5 days',
        status: 'new',
        indicatorColor: AppColor.kGoldColor,
        badgeColor: AppColor.kBorderColor,
        badgeTextColor: AppColor.kGrayTextColor,
      ),
      TaskItem(
        id: 'TSK-003',
        title: 'Marine Life Observation',
        owner: 'Dr. Ahmed',
        duration: 'Active',
        statusLabel: 'Active',
        status: 'in_progress',
        indicatorColor: AppColor.kPrimaryColor,
        badgeColor: AppColor.kPrimaryColor.withOpacity(0.1),
        badgeTextColor: AppColor.kPrimaryColor,
        hasImage: true,
      ),
      TaskItem(
        id: 'TSK-004',
        title: 'Resource Allocation Map',
        owner: 'Layla M.',
        duration: 'Waiting',
        statusLabel: 'Waiting',
        status: 'pending',
        indicatorColor: AppColor.kGoldColor,
        badgeColor: AppColor.kGoldColor.withOpacity(0.1),
        badgeTextColor: AppColor.kGoldColor,
      ),
      TaskItem(
        id: 'TSK-005',
        title: 'Initial Site Inspection',
        owner: 'Ali Al-Harbi',
        duration: 'Completed',
        statusLabel: 'Completed',
        status: 'ended',
        indicatorColor: AppColor.kGrayTextColor,
        badgeColor: AppColor.kPrimaryColor.withOpacity(0.1),
        badgeTextColor: AppColor.kPrimaryColor,
      ),
    ];

const List<({String key, String title})> taskKanbanColumns = [
  (key: 'new', title: 'جديد'),
  (key: 'in_progress', title: 'قيد التنفيذ'),
  (key: 'pending', title: 'قيد المراجعة'),
  (key: 'ended', title: 'مكتمل'),
];

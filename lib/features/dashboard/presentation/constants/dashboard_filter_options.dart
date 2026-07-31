import '../../../../../core/utils/app_string.dart';
import '../../data/models/dashboard_project_filters.dart';

enum ProjectFilterCategory {
  brands,
  productionLines,
  projectStatus,
  products,
  sizes,
  projectTypes,
}

extension ProjectFilterCategoryX on ProjectFilterCategory {
  String get labelKey {
    switch (this) {
      case ProjectFilterCategory.brands:
        return AppString.sector;
      case ProjectFilterCategory.productionLines:
        return AppString.productionLine;
      case ProjectFilterCategory.projectStatus:
        return AppString.projectStatus;
      case ProjectFilterCategory.products:
        return AppString.region;
      case ProjectFilterCategory.sizes:
        return AppString.types;
      case ProjectFilterCategory.projectTypes:
        return AppString.currentPhase;
    }
  }

  bool get isIntCategory =>
      this == ProjectFilterCategory.projectStatus ||
      this == ProjectFilterCategory.projectTypes;
}

extension DashboardProjectFiltersX on DashboardProjectFilters {
  bool hasCategorySelection(ProjectFilterCategory category) {
    switch (category) {
      case ProjectFilterCategory.brands:
        return brands.isNotEmpty;
      case ProjectFilterCategory.productionLines:
        return productionLines.isNotEmpty;
      case ProjectFilterCategory.projectStatus:
        return projectStatus.isNotEmpty;
      case ProjectFilterCategory.products:
        return products.isNotEmpty;
      case ProjectFilterCategory.sizes:
        return sizes.isNotEmpty;
      case ProjectFilterCategory.projectTypes:
        return projectTypes.isNotEmpty;
    }
  }
}

class DashboardIntFilterOption {
  const DashboardIntFilterOption({
    required this.value,
    required this.labelKey,
  });

  final int value;
  final String labelKey;
}

const dashboardProjectStatusFilterOptions = [
  DashboardIntFilterOption(
    value: 0,
    labelKey: AppString.projectStatusStarted,
  ),
  DashboardIntFilterOption(
    value: 1,
    labelKey: AppString.projectStatusAwarded,
  ),
  DashboardIntFilterOption(
    value: 2,
    labelKey: AppString.projectStatusSigned,
  ),
  DashboardIntFilterOption(
    value: 3,
    labelKey: AppString.projectStatusReviewCommittee,
  ),
  DashboardIntFilterOption(
    value: 4,
    labelKey: AppString.projectStatusAccreditation,
  ),
  DashboardIntFilterOption(
    value: 5,
    labelKey: AppString.projectStatusEnded,
  ),
  DashboardIntFilterOption(
    value: 6,
    labelKey: AppString.projectStatusTender,
  ),
];

const dashboardProjectTypeFilterOptions = [
  DashboardIntFilterOption(
    value: 0,
    labelKey: AppString.projectTypeStarted,
  ),
  DashboardIntFilterOption(
    value: 1,
    labelKey: AppString.projectTypeAwarded,
  ),
  DashboardIntFilterOption(
    value: 2,
    labelKey: AppString.projectTypeSigned,
  ),
  DashboardIntFilterOption(
    value: 3,
    labelKey: AppString.projectTypeReviewCommittee,
  ),
  DashboardIntFilterOption(
    value: 4,
    labelKey: AppString.projectTypeAccreditation,
  ),
  DashboardIntFilterOption(
    value: 5,
    labelKey: AppString.finished,
  ),
  DashboardIntFilterOption(
    value: 6,
    labelKey: AppString.projectTypeTender,
  ),
];

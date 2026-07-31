import '../../../../core/network/account_user_type.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/utils/app_string.dart';

enum FormBuildingRequestType {
  dxList,
  dxTitleList,
  accounts,
  suppliers,
  projectSteps,
}

enum FormBuildingModule {
  mainData,
  projectTemplates,
  sectors,
  regions,
  projectTypes,
  financialStatus,
  projectManagementStatus,
  projectStages,
  achievementRates,
  departments,
  positions,
  employees,
  contractors,
  roles,
  myTeam;

  /// Items shown under the standalone «بناء النماذج» drawer section.
  static List<FormBuildingModule> get formsBuilderModules => [
    FormBuildingModule.projectTemplates,
  ];

  /// Items shown under the «البيانات الرئيسية» drawer section.
  static List<FormBuildingModule> get mainDataModules => mainScreenModules;

  static List<FormBuildingModule> get mainScreenModules => [
    FormBuildingModule.sectors,
    FormBuildingModule.regions,
    FormBuildingModule.projectTypes,
    FormBuildingModule.financialStatus,
    FormBuildingModule.projectManagementStatus,
    FormBuildingModule.projectStages,
    FormBuildingModule.achievementRates,
    FormBuildingModule.departments,
    FormBuildingModule.positions,
    FormBuildingModule.employees,
    FormBuildingModule.contractors,
    FormBuildingModule.roles,
    FormBuildingModule.myTeam,
  ];
}

extension FormBuildingModuleX on FormBuildingModule {
  String get titleKey {
    switch (this) {
      case FormBuildingModule.mainData:
        return AppString.mainData;
      case FormBuildingModule.projectTemplates:
        return AppString.projectTemplates;
      case FormBuildingModule.sectors:
        return AppString.sectors;
      case FormBuildingModule.regions:
        return AppString.region;
      case FormBuildingModule.projectTypes:
        return AppString.projectTypeLabel;
      case FormBuildingModule.financialStatus:
        return AppString.financialStatus;
      case FormBuildingModule.projectManagementStatus:
        return AppString.projectManagementStatus;
      case FormBuildingModule.projectStages:
        return AppString.projectPhaseLabel;
      case FormBuildingModule.achievementRates:
        return AppString.projectAchievementRates;
      case FormBuildingModule.departments:
        return AppString.departments;
      case FormBuildingModule.positions:
        return AppString.positions;
      case FormBuildingModule.employees:
        return AppString.employees;
      case FormBuildingModule.contractors:
        return AppString.contractors;
      case FormBuildingModule.roles:
        return AppString.roles;
      case FormBuildingModule.myTeam:
        return AppString.myTeam;
    }
  }

  /// Permission required to show this module in the drawer. Null = always show.
  String? get viewPermission {
    switch (this) {
      case FormBuildingModule.mainData:
        return null;
      case FormBuildingModule.projectTemplates:
        return AppPermissions.projectTemplateView;
      case FormBuildingModule.sectors:
        return AppPermissions.brandView;
      case FormBuildingModule.regions:
        return AppPermissions.productView;
      case FormBuildingModule.projectTypes:
        return AppPermissions.sizeMlView;
      case FormBuildingModule.financialStatus:
        return AppPermissions.financialStatusView;
      case FormBuildingModule.projectManagementStatus:
        return AppPermissions.pmStatusView;
      case FormBuildingModule.projectStages:
        return AppPermissions.pStepsView;
      case FormBuildingModule.achievementRates:
        return AppPermissions.projectAchievementManualView;
      case FormBuildingModule.departments:
        return AppPermissions.departmentView;
      case FormBuildingModule.positions:
        return AppPermissions.designationView;
      case FormBuildingModule.employees:
        return AppPermissions.userView;
      case FormBuildingModule.contractors:
        return AppPermissions.supplierView;
      case FormBuildingModule.roles:
        return AppPermissions.roleView;
      case FormBuildingModule.myTeam:
        return AppPermissions.userView;
    }
  }

  String get endpoint {
    switch (this) {
      case FormBuildingModule.mainData:
      case FormBuildingModule.achievementRates:
        return '';
      case FormBuildingModule.projectTemplates:
        return PmoEndpoints.projectTemplate;
      case FormBuildingModule.sectors:
        return PmoEndpoints.brandListDx;
      case FormBuildingModule.regions:
        return PmoEndpoints.productListDx;
      case FormBuildingModule.projectTypes:
        return PmoEndpoints.sizeMlListDx;
      case FormBuildingModule.financialStatus:
        return PmoEndpoints.financialStatusListDx;
      case FormBuildingModule.projectManagementStatus:
        return PmoEndpoints.pmStatusListDx;
      case FormBuildingModule.projectStages:
        return PmoEndpoints.projectStepListDx;
      case FormBuildingModule.departments:
        return PmoEndpoints.departmentListDx;
      case FormBuildingModule.positions:
        return PmoEndpoints.positionListDx;
      case FormBuildingModule.employees:
        return PmoEndpoints.accountListDx;
      case FormBuildingModule.contractors:
        return PmoEndpoints.supplierListDx;
      case FormBuildingModule.roles:
        return PmoEndpoints.roleListDx;
      case FormBuildingModule.myTeam:
        return PmoEndpoints.myTeamListDx;
    }
  }

  FormBuildingRequestType get requestType {
    switch (this) {
      case FormBuildingModule.mainData:
      case FormBuildingModule.projectTemplates:
      case FormBuildingModule.achievementRates:
        return FormBuildingRequestType.dxList;
      case FormBuildingModule.sectors:
      case FormBuildingModule.regions:
      case FormBuildingModule.projectTypes:
      case FormBuildingModule.departments:
      case FormBuildingModule.positions:
      case FormBuildingModule.roles:
      case FormBuildingModule.myTeam:
        return FormBuildingRequestType.dxList;
      case FormBuildingModule.financialStatus:
      case FormBuildingModule.projectManagementStatus:
        return FormBuildingRequestType.dxTitleList;
      case FormBuildingModule.projectStages:
        return FormBuildingRequestType.projectSteps;
      case FormBuildingModule.employees:
        return FormBuildingRequestType.accounts;
      case FormBuildingModule.contractors:
        return FormBuildingRequestType.suppliers;
    }
  }

  int? get accountUserType {
    switch (this) {
      case FormBuildingModule.employees:
        return AccountUserType.normalUser;
      default:
        return null;
    }
  }

  int? get supplierType {
    switch (this) {
      case FormBuildingModule.contractors:
        return 1;
      default:
        return null;
    }
  }

  bool get usesDedicatedScreen =>
      this == FormBuildingModule.mainData ||
      this == FormBuildingModule.projectTemplates ||
      this == FormBuildingModule.achievementRates;
}

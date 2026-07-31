import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/service_locator.dart';

import '../../achievement_rates_management/presentation/screens/achievement_rates_management_screen.dart';
import '../../contractors/presentation/screens/contractors_management_screen.dart';
import '../../departments/presentation/screens/departments_management_screen.dart';
import '../../employees/presentation/screens/employees_management_screen.dart';
import '../../financial_statuses/presentation/screens/financial_statuses_management_screen.dart';
import '../../pm_statuses/presentation/screens/pm_statuses_management_screen.dart';
import '../../positions/presentation/screens/positions_management_screen.dart';
import '../../project_stages/presentation/screens/project_stages_management_screen.dart';
import '../../project_templates/presentation/screens/project_templates_management_screen.dart';
import '../../project_types/presentation/screens/project_types_management_screen.dart';
import '../../regions/presentation/screens/regions_management_screen.dart';
import '../../roles/presentation/screens/roles_management_screen.dart';
import '../../sectors/presentation/screens/sectors_management_screen.dart';
import '../domain/models/form_building_module.dart';
import 'cubit/form_building_list_cubit.dart';

import 'screens/form_building_list_screen.dart';
import 'screens/form_building_main_screen.dart';

abstract final class FormBuildingScreenFactory {
  static Widget build(FormBuildingModule module) {
    if (module == FormBuildingModule.mainData) {
      return const FormBuildingMainScreen();
    }

    if (module == FormBuildingModule.projectTemplates) {
      return const ProjectTemplatesManagementScreen();
    }

    if (module == FormBuildingModule.achievementRates) {
      return const AchievementRatesManagementScreen();
    }

    if (module == FormBuildingModule.sectors) {
      return const SectorsManagementScreen();
    }

    if (module == FormBuildingModule.regions) {
      return const RegionsManagementScreen();
    }

    if (module == FormBuildingModule.projectTypes) {
      return const ProjectTypesManagementScreen();
    }

    if (module == FormBuildingModule.financialStatus) {
      return const FinancialStatusesManagementScreen();
    }

    if (module == FormBuildingModule.projectManagementStatus) {
      return const PmStatusesManagementScreen();
    }

    if (module == FormBuildingModule.projectStages) {
      return const ProjectStagesManagementScreen();
    }

    if (module == FormBuildingModule.departments) {
      return const DepartmentsManagementScreen();
    }

    if (module == FormBuildingModule.positions) {
      return const PositionsManagementScreen();
    }

    if (module == FormBuildingModule.contractors) {
      return const ContractorsManagementScreen();
    }

    if (module == FormBuildingModule.roles) {
      return const RolesManagementScreen();
    }

    if (module == FormBuildingModule.employees) {
      return const EmployeesManagementScreen();
    }

    return BlocProvider(
      create: (_) => sl<FormBuildingListCubit>(param1: module)..load(),
      child: FormBuildingListScreen(module: module),
    );
  }
}

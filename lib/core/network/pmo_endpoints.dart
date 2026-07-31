class PmoEndpoints {
  static const String login = 'account/login';
  static const String refreshToken = 'account/refresh-token';
  static const String account = 'account';
  static const String projectSearch = 'project/search';
  static const String projectDxList = 'Project/dx/list';
  static const String projectStepListDx = 'ProjectStep/list/dx';
  static const String projectSteps = 'projectstep';
  static const String projectStepCreate = 'ProjectStep/create';
  static const String projectStepUpdate = 'ProjectStep/update';
  static const String projectStepDelete = 'ProjectStep/delete';
  static const String pStepsListDx = 'PSteps/list/dx';
  static const String achievementManualListDx =
      'ProjectAchievementManual/list/dx';
  static const String achievementManualCreate =
      'ProjectAchievementManual/create';
  static const String achievementManualUpdate =
      'ProjectAchievementManual/update';
  static const String achievementManualDelete =
      'ProjectAchievementManual/delete';
  static const String projectRiskListDx = 'ProjectRisk/list/dx';
  static String projectRiskListByProject(String projectId) =>
      'ProjectRisk/list/dx/$projectId';
  static const String createProjectRisk = 'ProjectRisk/CreateProjectRisk';
  static const String updateProjectRisk = 'ProjectRisk/UpdateProjectRisk';
  static const String deleteProjectRisk = 'ProjectRisk/DeleteProjectRisk';
  static const String accountListDx = 'account/list/dx';
  static const String accountListDetailsDx = 'account/listDetails/dx';
  static const String accountAddUser = 'account/AddUser';
  static const String accountUpdateUser = 'account/updateUser';
  static const String accountResetPassword = 'account/resetPassword';
  static const String accountDeleteDx = 'account/dx';
  static const String supplierListDx = 'Supplier/list/dx';
  static const String supplierCreate = 'Supplier/CreateSupplier';
  static const String supplierUpdate = 'Supplier/UpdateSupplier';
  static const String supplierDelete = 'Supplier/DeleteSupplier';
  static const String financialStatement = 'FinancialStatement';
  static const String deleteFinancialStatement = 'FinancialStatement/delete';
  static const String createFinancialStatement = 'FinancialStatement/create';
  static const String financialStatementCount =
      'FinancialStatement/statement-count';
  static const String financialStatementSum =
      'FinancialStatement/statement-sum';
  static const String financialStatusListDx = 'FinancialStatus/list/dx';
  static const String financialStatusCreate = 'FinancialStatus/create';
  static const String financialStatusUpdate = 'FinancialStatus/update';
  static const String financialStatusDelete = 'FinancialStatus/delete';
  static const String brandListDx = 'brand/list/dx';
  static const String brandCreate = 'brand/create';
  static const String brandUpdate = 'brand/update';
  static const String brandDelete = 'brand/delete';
  static const String productListDx = 'product/list/dx';
  static const String productCreate = 'product/create';
  static const String productUpdate = 'product/update';
  static const String productDelete = 'product/delete';
  static const String sizeMlListDx = 'sizeML/list/dx';
  static const String sizeMlListDxApi = 'sizeml/list/dx';
  static const String sizeMlCreate = 'sizeml/create';
  static const String sizeMlUpdate = 'sizeml/update';
  static const String sizeMlDelete = 'sizeml/delete';
  static const String pmStatusListDx = 'PMStatus/list/dx';
  static const String pmStatusCreate = 'PMStatus/create';
  static const String pmStatusUpdate = 'PMStatus/update';
  static const String pmStatusDelete = 'PMStatus/delete';
  static const String projectTemplatePublished = 'Project/Template/published';
  static const String projectTemplate = 'Project/Template';

  static String projectTemplateGantt(String templateId) =>
      'Project/Template/gantt/$templateId';
  static const String createProject = 'project';

  static String projectById(String id) => 'project/$id';
  static String projectImages(String projectId) => 'project/images/$projectId';
  static const String productionLineListDx = 'ProductionLine/listAll/dx';
  static const String departmentListDx = 'department/list/dx';
  static const String departmentCreate = 'department/create';
  static const String departmentUpdate = 'department/update';
  static const String departmentDelete = 'department/delete';
  static const String positionListDx = 'designation/list/dx';
  static const String designationListDx = 'designation/list/dx';
  static const String designationCreate = 'designation/create';
  static const String designationUpdate = 'designation/update';
  static const String designationDelete = 'designation/delete';
  static const String roleListDx = 'roles/list/dx';
  static const String roleCreate = 'roles/dx';
  static const String roleDetails = 'roles';
  static const String roleUpdate = 'roles/update';
  static const String myTeamListDx = 'Team/list/dx';

  // User-to-user chat
  static const String chatList = 'Chat/list';
  static const String chatSendMessage = 'Chat/send-message';
  static const String chatStart = 'Chat/start-chat';
  static const String chatCreateGroup = 'Chat/create-group-chat';
  static String chatListMessages(String chatId) => 'Chat/list-messages/$chatId';

  static const String projectRequestsSummary = 'ProjectRequests/summary';
  static const String projectRequestsMyRequests = 'ProjectRequests/my-requests';
  static const String projectRequestsMyRequestsCounts =
      'ProjectRequests/my-requests/counts';
  static const String requestTaskMyTasks = 'RequestTask/my-tasks';
  static const String requestTaskMyTasksCounts = 'RequestTask/my-tasks/counts';
  static const String projectRequestsArchive = 'ProjectRequests/archive';
  static const String projectRequestsCreate = 'ProjectRequests';
  static const String projectRequestsInsertNumbers =
      'ProjectRequests/insert-numbers';

  static String projectRequestById(String id) => 'ProjectRequests/$id';

  static String projectRequestTaskAction(String taskId) =>
      'ProjectRequests/tasks/$taskId/action';

  static String projectRequestHistory(String id) =>
      'ProjectRequests/$id/history';

  static String projectRequestAttachmentsHierarchy(String id) =>
      'ProjectRequests/attachments/$id/hierarchy';

  /// GET file bytes by attachment UUID (swagger: /ProjectRequests/attachments/{attachmentId}).
  static String projectRequestAttachmentById(String attachmentId) =>
      'ProjectRequests/attachments/$attachmentId';

  /// Legacy — not in current swagger; kept only as last-resort fallback.
  static const String projectRequestAttachmentDownload =
      'ProjectRequests/attachments/download';

  static String projectGetForEdit(String id) => 'project/GetProjectForEdit/$id';

  static String projectStepById(String id) => 'projectstep/$id';

  static String projectStatistics(String projectId, String segment) =>
      'project/$projectId/statistics/$segment';

  static String projectData(String projectId) =>
      projectStatistics(projectId, 'project-data');

  static String projectExecutiveSummary(String projectId) =>
      projectStatistics(projectId, 'project-executive-summary');

  static String projectStages(String projectId) =>
      projectStatistics(projectId, 'stages');

  static String projectStatements(String projectId) =>
      projectStatistics(projectId, 'project-statements');

  static String projectAchievement(String projectId) =>
      projectStatistics(projectId, 'project-achievement');

  static String projectRiskMatrix(String projectId) =>
      projectStatistics(projectId, 'risk-matrix');

  static String projectQcTechnical(String projectId) =>
      projectStatistics(projectId, 'qc-technical');

  static String projectQcAcceptedWork(String projectId) =>
      projectStatistics(projectId, 'qc-acceptedwork');

  static String projectCharterByProjectId(String projectId) =>
      'ProjectCharters/$projectId';

  static String projectCharterAchievements(String projectId) =>
      'project-charters/$projectId/achievements';

  static String projectCharterStages(String projectId) =>
      'project-charters/$projectId/stages';

  static String projectCharterConstraints(String projectId) =>
      'project-charters/$projectId/constraints';

  static String projectCharterAttachments(String projectId) =>
      'project-charters/$projectId/attachments';

  static const String projectStatisticsGeneral = 'project-statistics/general';
  static const String projectStatisticsAreaProject =
      'project-statistics/area-project';
  static const String projectStatisticsSectorProjects =
      'project-statistics/sector-projects';
  static const String projectStatisticsQcTechnical =
      'project-statistics/qc-technical';
  static const String projectStatisticsCountByType =
      'project-statistics/count-by-type';
  static const String projectStatisticsProjectStatusCounts =
      'project-statistics/project-status-counts';
  static const String financialProjectExecutionSummary =
      'financial-statistics/project-execution-summary';
  static const String projectStatisticsProjectsStatusCountsSectors =
      'project-statistics/projects-status-counts-sectors';
  static const String financialStatementProjects =
      'FinancialStatement/statement-Projects';
  static const String projectStatisticsFinancialSectors =
      'project-statistics/projects-Statistics-Financial-Sectors';
  static const String brandBrands = 'Brand/Brands';

  static const String meetings = 'meetings';
  static String meetingById(String id) => 'meetings/$id';

  static Map<String, dynamic> regionQuery(String? regionId) => {
    'regionId': regionId ?? 'null',
  };

  static Map<String, dynamic> brandQuery(String? brandId) {
    if (brandId == null || brandId.isEmpty) return const {};
    return {'BrandId': brandId};
  }

  /// Login must never send a stored Bearer token (expired token → 401).
  static bool isLoginPath(String path) {
    final normalized = _normalizePath(path);
    return normalized == login ||
        normalized.endsWith('/$login') ||
        normalized.contains('/$login');
  }

  static bool isRefreshTokenPath(String path) {
    final normalized = _normalizePath(path);
    return normalized == refreshToken ||
        normalized.endsWith('/$refreshToken') ||
        normalized.contains('/$refreshToken');
  }

  static bool isPublicAuthPath(String path) =>
      isLoginPath(path) || isRefreshTokenPath(path);

  static bool requiresAuth(String path) => !isPublicAuthPath(path);

  static String _normalizePath(String path) {
    var value = path.trim().toLowerCase();
    if (value.isEmpty) return value;

    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      value = uri.path;
    }

    value = value.split('?').first;
    if (value.startsWith('/')) {
      value = value.substring(1);
    }
    if (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }
}

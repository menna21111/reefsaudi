class PmoEndpoints {
  static const String login = 'account/login';
  static const String account = 'account';
  static const String projectSearch = 'project/search';
  static const String projectDxList = 'Project/dx/list';
  static const String projectStepListDx = 'projectstep/list/dx';
  static const String projectSteps = 'projectstep';
  static const String achievementManualListDx = 'ProjectAchievementManual/list/dx';
  static const String projectRiskListDx = 'ProjectRisk/list/dx';
  static const String createProjectRisk = 'ProjectRisk/CreateProjectRisk';
  static const String accountListDx = 'account/list/dx';
  static const String financialStatement = 'FinancialStatement';

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

  static const String projectStatisticsGeneral = 'project-statistics/general';
  static const String projectStatisticsAreaProject =
      'project-statistics/area-project';
  static const String projectStatisticsSectorProjects =
      'project-statistics/sector-projects';
  static const String projectStatisticsQcTechnical =
      'project-statistics/qc-technical';
  static const String financialProjectExecutionSummary =
      'financial-statistics/project-execution-summary';

  static Map<String, dynamic> regionQuery(String? regionId) => {
        'regionId': regionId ?? 'null',
      };

  /// Login must never send a stored Bearer token (expired token → 401).
  static bool isLoginPath(String path) {
    final normalized = _normalizePath(path);
    return normalized == login ||
        normalized.endsWith('/$login') ||
        normalized.contains('/$login');
  }

  static bool requiresAuth(String path) => !isLoginPath(path);

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

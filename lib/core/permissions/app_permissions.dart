/// PMO API permission keys from [ProfileModel.grantedPermissions].
abstract final class AppPermissions {
  // Project
  static const projectView = 'Permissions.Project.View';
  static const projectCreate = 'Permissions.Project.Create';
  static const projectEdit = 'Permissions.Project.Edit';
  static const projectDelete = 'Permissions.Project.Delete';
  static const projectAttachments = 'Permissions.Project.Attachments';
  static const projectGantt = 'Permissions.Project.Gantt';
  static const projectBacklog = 'Permissions.Project.Backlog';
  static const projectRequests = 'Permissions.Project.ProjectRequests';

  // Dashboard
  static const dashboardView = 'Permissions.Dashboard.View';
  static const dashboardCreate = 'Permissions.Dashboard.Create';
  static const dashboardEdit = 'Permissions.Dashboard.Edit';

  // Tasks
  static const taskView = 'Permissions.Task.View';
  static const taskCreate = 'Permissions.Task.Create';
  static const taskEdit = 'Permissions.Task.Edit';
  static const taskDelete = 'Permissions.Task.Delete';

  static const taskManagementView = 'Permissions.TaskManagement.View';
  static const requestTaskView = 'Permissions.RequestTask.View';
  static const requestTaskCreate = 'Permissions.RequestTask.Create';
  static const requestTaskEdit = 'Permissions.RequestTask.Edit';
  static const requestTaskDelete = 'Permissions.RequestTask.Delete';

  // Extracts (المستخلصات)
  static const financialStatementView = 'Permissions.FinancialStatement.View';
  static const financialStatementCreate =
      'Permissions.FinancialStatement.Create';
  static const financialStatementEdit = 'Permissions.FinancialStatement.Edit';
  static const financialStatementDelete =
      'Permissions.FinancialStatement.Delete';

  // Achievement rates (إدارة نسب الإنجاز)
  static const projectAchievementManualView =
      'Permissions.ProjectAchievementManual.View';
  static const projectAchievementManualCreate =
      'Permissions.ProjectAchievementManual.Create';
  static const projectAchievementManualEdit =
      'Permissions.ProjectAchievementManual.Edit';
  static const projectAchievementManualDelete =
      'Permissions.ProjectAchievementManual.Delete';

  // Master data / forms builder
  static const brandView = 'Permissions.Brand.View';
  static const productView = 'Permissions.Product.View';
  static const sizeMlView = 'Permissions.sizeml.View';
  static const financialStatusView = 'Permissions.FinancialStatus.View';
  static const pmStatusView = 'Permissions.PMStatus.View';
  static const pStepsView = 'Permissions.PSteps.View';
  static const departmentView = 'Permissions.Department.View';
  static const designationView = 'Permissions.Designation.View';
  static const userView = 'Permissions.User.View';
  static const supplierView = 'Permissions.Supplier.View';
  static const roleView = 'Permissions.Role.View';
  static const projectTemplateView = 'Permissions.ProjectTemplate.View';
  static const dynamicFormView = 'Permissions.DynamicForm.View';

  // Legacy / other financial
  static const financialView = 'Permissions.SupplierOrder.View';
  static const quotationView = 'Permissions.QuotationRequest.View';
}

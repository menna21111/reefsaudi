/// PMO API permission keys from [ProfileModel.grantedPermissions].
abstract final class AppPermissions {
  static const projectView = 'Permissions.Project.View';
  static const projectCreate = 'Permissions.Project.Create';
  static const projectEdit = 'Permissions.Project.Edit';
  static const projectDelete = 'Permissions.Project.Delete';
  static const projectAttachments = 'Permissions.Project.Attachments';
  static const projectGantt = 'Permissions.Project.Gantt';
  static const projectBacklog = 'Permissions.Project.Backlog';

  static const dashboardView = 'Permissions.Dashboard.View';
  static const dashboardCreate = 'Permissions.Dashboard.Create';
  static const dashboardEdit = 'Permissions.Dashboard.Edit';

  static const taskView = 'Permissions.Task.View';
  static const taskCreate = 'Permissions.Task.Create';
  static const taskEdit = 'Permissions.Task.Edit';
  static const taskDelete = 'Permissions.Task.Delete';

  static const taskManagementView = 'Permissions.TaskManagement.View';
  static const financialView = 'Permissions.SupplierOrder.View';
  static const quotationView = 'Permissions.QuotationRequest.View';
}

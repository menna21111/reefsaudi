/// Decision for standard approval tasks (when [approvalActionId] is null).
enum TaskApprovalDecision {
  approved,
  rejected,
  reRequest,
}

extension TaskApprovalDecisionX on TaskApprovalDecision {
  String get labelKey => switch (this) {
        TaskApprovalDecision.approved => 'qc_status_accepted',
        TaskApprovalDecision.rejected => 'qc_status_rejected',
        TaskApprovalDecision.reRequest => 'qc_status_re_request',
      };
}

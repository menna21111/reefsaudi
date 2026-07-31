import 'package:dio/dio.dart';

import '../../domain/models/task_approval_decision.dart';
import 'create_project_request_models.dart';

class ProjectRequestTaskActionPayload {
  const ProjectRequestTaskActionPayload({
    this.decision,
    this.approvalId,
    this.comment = '',
    this.attachmentPath,
  }) : assert(
          decision != null || approvalId != null,
          'Either decision or approvalId is required',
        );

  final TaskApprovalDecision? decision;
  final int? approvalId;
  final String comment;
  final String? attachmentPath;

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};

    if (approvalId != null) {
      map['approvalId'] = approvalId;
    } else if (decision != null) {
      switch (decision!) {
        case TaskApprovalDecision.approved:
          map['isApproved'] = true;
        case TaskApprovalDecision.rejected:
          map['isApproved'] = false;
        case TaskApprovalDecision.reRequest:
          map['isReRequest'] = true;
      }
    }

    final trimmedComment = comment.trim();
    if (trimmedComment.isNotEmpty) {
      map['comment'] = trimmedComment;
    }

    final path = attachmentPath;
    if (path != null && path.isNotEmpty) {
      map['attachments'] = await multipartFromLocalPath(path);
    }

    return FormData.fromMap(map);
  }
}

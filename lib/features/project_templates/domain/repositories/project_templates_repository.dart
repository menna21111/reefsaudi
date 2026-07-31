import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/project_template.dart';

abstract class ProjectTemplatesRepository {
  Future<Either<Failure, ProjectTemplateListResult>> getProjectTemplates({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createProjectTemplate(
    ProjectTemplateWriteRequest request,
  );

  Future<Either<Failure, void>> updateProjectTemplate({
    required String id,
    required ProjectTemplateWriteRequest request,
  });

  Future<Either<Failure, void>> deleteProjectTemplate(String id);

  Future<Either<Failure, TemplateGanttData>> getTemplateGantt(
    String templateId,
  );

  Future<Either<Failure, void>> saveTemplateGantt({
    required String templateId,
    required TemplateGanttData data,
    required TemplateGanttAction action,
  });
}

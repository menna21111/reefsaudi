import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/models/project_template.dart';
import '../../domain/repositories/project_templates_repository.dart';
import '../datasources/project_templates_remote_data_source.dart';

class ProjectTemplatesRepositoryImpl implements ProjectTemplatesRepository {
  ProjectTemplatesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final ProjectTemplatesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }

    try {
      return Right(await call());
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, ProjectTemplateListResult>> getProjectTemplates({
    required int skip,
    required int take,
    String? searchText,
  }) => _guard(
    () => remoteDataSource.getProjectTemplates(
      skip: skip,
      take: take,
      searchText: searchText,
    ),
  );

  @override
  Future<Either<Failure, void>> createProjectTemplate(
    ProjectTemplateWriteRequest request,
  ) => _guard(() => remoteDataSource.createProjectTemplate(request));

  @override
  Future<Either<Failure, void>> updateProjectTemplate({
    required String id,
    required ProjectTemplateWriteRequest request,
  }) => _guard(
    () => remoteDataSource.updateProjectTemplate(id: id, request: request),
  );

  @override
  Future<Either<Failure, void>> deleteProjectTemplate(String id) =>
      _guard(() => remoteDataSource.deleteProjectTemplate(id));

  @override
  Future<Either<Failure, TemplateGanttData>> getTemplateGantt(
    String templateId,
  ) => _guard(() => remoteDataSource.getTemplateGantt(templateId));

  @override
  Future<Either<Failure, void>> saveTemplateGantt({
    required String templateId,
    required TemplateGanttData data,
    required TemplateGanttAction action,
  }) =>
      _guard(
        () => remoteDataSource.saveTemplateGantt(
          templateId: templateId,
          data: data,
          action: action,
        ),
      );
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../entities/project.dart';
import '../repositories/dashboard_repository.dart';

class GetProjectsUseCase extends UseCase2<List<Project>, NoParams> {
  final DashboardRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) async {
    return await repository.getProjects();
  }
}

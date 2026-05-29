import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<Project>>> getProjects();
}

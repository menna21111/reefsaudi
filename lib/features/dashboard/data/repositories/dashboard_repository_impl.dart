import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/project_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    try {
      // Mocking project data exactly matching the screenshot
      final projects = [
        const ProjectModel(
          id: '1',
          title: 'العسل - الباحة - إنشاءات',
          description: 'أعمال إنشائية في محطة ملكات النحل ببلجرشي',
          budget: 6000000.0,
          status: 'stalled',
          progress: 42.0,
          entityName: 'منصة اعتماد',
          daysLeft: 99,
        ),
        const ProjectModel(
          id: '2',
          title: 'الفاكهة - الرياض - توريدات',
          description: 'توريد وتركيب منشآت لمركز مكافحة الأمراض النباتية',
          budget: 2070000.0,
          status: 'finished',
          progress: 100.0,
          entityName: 'شركة الخريف',
          daysLeft: null,
        ),
        const ProjectModel(
          id: '3',
          title: 'القمح - الجوف - زراعة',
          description: 'تطوير وتأهيل حقول القمح المطرية بمحافظة دومة الجندل',
          budget: 4500000.0,
          status: 'in_progress',
          progress: 68.0,
          entityName: 'الوزارة',
          daysLeft: 120,
        ),
      ];
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      return Right(projects);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

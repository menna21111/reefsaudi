import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/account_user_type.dart';
import '../../data/datasources/edit_project_remote_data_source.dart';
import '../../data/models/create_project_request.dart';
import '../../data/models/update_project_request.dart';
import '../../data/models/project_edit_models.dart';
import '../../data/models/project_template_models.dart';
import '../../domain/repositories/project_repository.dart';
import '../../../risk_management/data/models/project_risk_models.dart';
import 'edit_project_state.dart';

class EditProjectCubit extends Cubit<EditProjectState> {
  EditProjectCubit({
    required EditProjectRemoteDataSource dataSource,
    required ProjectRepository repository,
  })  : _dataSource = dataSource,
        _repository = repository,
        super(EditProjectInitial());

  final EditProjectRemoteDataSource _dataSource;
  final ProjectRepository _repository;

  List<AccountDxItemDto>? _accountsCache;
  List<AccountDxItemDto>? _consultantsCache;
  List<AccountDxItemDto>? _contractorsCache;
  List<DxListItemDto>? _brandsCache;
  List<DxListItemDto>? _productsCache;
  List<DxListItemDto>? _projectTypesCache;
  List<DxListItemDto>? _productionLinesCache;
  List<ProjectTemplateDto>? _templatesCache;

  void initForCreate() {
    _clearLookupCaches();
    emit(
      EditProjectLoaded(
        projectId: '',
        form: EditProjectFormData.empty(),
      ),
    );
  }

  void _clearLookupCaches() {
    _accountsCache = null;
    _consultantsCache = null;
    _contractorsCache = null;
    _brandsCache = null;
    _productsCache = null;
    _projectTypesCache = null;
    _productionLinesCache = null;
    _templatesCache = null;
  }

  Future<void> loadProject(String projectId) async {
    _clearLookupCaches();
    emit(EditProjectLoading());
    try {
      final project = await _dataSource.getProjectForEdit(projectId);
      emit(
        EditProjectLoaded(
          projectId: projectId,
          form: EditProjectFormData.fromDto(project),
        ),
      );
    } catch (error) {
      emit(EditProjectError(error.toString()));
    }
  }

  void updateForm(EditProjectFormData form) {
    final current = state;
    if (current is! EditProjectLoaded) return;
    emit(current.copyWith(form: form, clearSubmitError: true));
  }

  Future<List<AccountDxItemDto>> loadAccounts() async {
    _accountsCache ??= await _dataSource.getAccounts();
    return _accountsCache!;
  }

  Future<List<AccountDxItemDto>> loadAccountsByUserType(int userType) async {
    switch (userType) {
      case AccountUserType.consultant:
        return loadConsultants();
      case AccountUserType.contractor:
        return loadContractors();
      default:
        return _dataSource.getAccountsByUserType(userType);
    }
  }

  Future<List<AccountDxItemDto>> loadConsultants() async {
    _consultantsCache ??=
        await _dataSource.getAccountsByUserType(AccountUserType.consultant);
    return _consultantsCache!;
  }

  Future<List<AccountDxItemDto>> loadContractors() async {
    _contractorsCache ??=
        await _dataSource.getAccountsByUserType(AccountUserType.contractor);
    return _contractorsCache!;
  }

  Future<List<DxListItemDto>> loadBrands() async {
    _brandsCache ??= await _dataSource.getBrands();
    return _brandsCache!;
  }

  Future<List<DxListItemDto>> loadProducts() async {
    _productsCache ??= await _dataSource.getProducts();
    return _productsCache!;
  }

  Future<List<DxListItemDto>> loadProjectTypes() async {
    _projectTypesCache ??= await _dataSource.getProjectTypes();
    return _projectTypesCache!;
  }

  Future<List<DxListItemDto>> loadProductionLines() async {
    _productionLinesCache ??= await _dataSource.getProductionLines();
    return _productionLinesCache!;
  }

  Future<List<ProjectTemplateDto>> loadPublishedTemplates() async {
    _templatesCache ??= await _dataSource.getPublishedTemplates();
    return _templatesCache!;
  }

  Future<String?> submit() async {
    final current = state;
    if (current is! EditProjectLoaded || current.isSubmitting) return null;

    emit(current.copyWith(isSubmitting: true, clearSubmitError: true));

    if (current.isCreateMode) {
      final result = await _repository.createProject(
        _buildCreateRequest(current.form),
      );

      return result.fold(
        (failure) {
          if (isClosed) return null;
          emit(
            current.copyWith(
              isSubmitting: false,
              submitError: failure.errMessage,
            ),
          );
          return null;
        },
        (_) {
          if (isClosed) return null;
          emit(current.copyWith(isSubmitting: false));
          return '';
        },
      );
    }

    final result = await _repository.updateProject(
      _buildUpdateRequest(current.projectId, current.form),
    );

    return result.fold(
      (failure) {
        if (isClosed) return null;
        emit(
          current.copyWith(
            isSubmitting: false,
            submitError: failure.errMessage,
          ),
        );
        return null;
      },
      (message) {
        if (isClosed) return null;
        emit(current.copyWith(isSubmitting: false));
        return message ?? '';
      },
    );
  }

  UpdateProjectRequest _buildUpdateRequest(
    String projectId,
    EditProjectFormData form,
  ) {
    String? nonEmpty(String? value) {
      if (value == null) return null;
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    String? formatDate(DateTime? date) {
      if (date == null) return null;
      final d = DateTime.utc(date.year, date.month, date.day);
      final y = d.year.toString().padLeft(4, '0');
      final m = d.month.toString().padLeft(2, '0');
      final day = d.day.toString().padLeft(2, '0');
      return '$y-$m-${day}T00:00:00';
    }

    double parseBudget(String value) {
      return double.tryParse(value.replaceAll(',', '').trim()) ?? 0;
    }

    int statusCode = 0;
    if (form.statusKey != null) {
      final index = projectStatusOptions.indexOf(form.statusKey!);
      if (index >= 0) statusCode = index;
    }

    Map<String, dynamic>? currentStep;
    if (form.phaseKey != null) {
      final type = projectPhaseOptions.indexOf(form.phaseKey!);
      if (type >= 0) {
        currentStep = {
          'type': type,
          'startedAt': formatDate(form.phaseJoinDate) ??
              formatDate(DateTime.now())!,
          if (form.phaseDurationInDays != null)
            'durationInDays': form.phaseDurationInDays,
          'progressRatio': form.phaseProgressRatio,
          'status': form.phaseStatus,
        };
      }
    }

    return UpdateProjectRequest(
      id: projectId,
      title: form.title.trim(),
      description: form.description.trim(),
      ownerId: nonEmpty(form.owner.id) ?? '',
      estimatedBudget: parseBudget(form.estimatedBudget),
      contractualBudget: parseBudget(form.contractualBudget),
      consultantId: nonEmpty(form.consultant.id),
      endDate: formatDate(form.endDate),
      startDate: formatDate(form.startDate),
      contractorId: nonEmpty(form.contractor.id),
      status: statusCode,
      tagNames: form.tagNames,
      currentStep: currentStep,
      projectCode: nonEmpty(form.projectCode),
      brandId: nonEmpty(form.sector.id),
      productId: nonEmpty(form.region.id),
      sizeMLId: nonEmpty(form.projectType.id),
      productionLineId: nonEmpty(form.productionLine.id),
      civilEngineerId: nonEmpty(form.civilEngineer.id),
      architecturalEngineerId: nonEmpty(form.architecturalEngineer.id),
      electricalEngineerId: nonEmpty(form.electricalEngineer.id),
      mechanicalEngineerId: nonEmpty(form.mechanicalEngineer.id),
      surveyEngineerId: nonEmpty(form.surveyEngineer.id),
      agriculturalEngineerId: nonEmpty(form.agriculturalEngineer.id),
      generalEngineerId: nonEmpty(form.generalEngineer.id),
      supervisionEngineerId: nonEmpty(form.supervisionEngineer.id),
      supervisionConsultantId: nonEmpty(form.supervisionConsultant.id),
      projectManagementConsultantId:
          nonEmpty(form.projectManagementConsultant.id),
      architecturalOfficerId: nonEmpty(form.architecturalOfficer.id),
      mechanicalOfficerId: nonEmpty(form.mechanicalOfficer.id),
      electricalOfficerId: nonEmpty(form.electricalOfficer.id),
      receiveBusinessId: nonEmpty(form.receiveBusiness.id),
      documentsAdoptionId: nonEmpty(form.documentsAdoption.id),
      executiveBoardsAdoptionId: nonEmpty(form.executiveBoardsAdoption.id),
      materialsAdoptionId: nonEmpty(form.materialsAdoption.id),
      subcontractorAdoptionId: nonEmpty(form.subcontractorAdoption.id),
      materialsReceiveAndInspectId:
          nonEmpty(form.materialsReceiveAndInspect.id),
      informationRequestId: nonEmpty(form.informationRequest.id),
      siteWorkInstructionsId: nonEmpty(form.siteWorkInstructions.id),
      paymentCertificateAdoptionId:
          nonEmpty(form.paymentCertificateAdoption.id),
      siteObservationReportId: nonEmpty(form.siteObservationReport.id),
      nonConformanceReportId: nonEmpty(form.nonConformanceReport.id),
    );
  }

  CreateProjectRequest _buildCreateRequest(EditProjectFormData form) {
    String? nonEmpty(String? value) {
      if (value == null) return null;
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    String? formatDate(DateTime? date) {
      if (date == null) return null;
      return DateTime.utc(date.year, date.month, date.day).toIso8601String();
    }

    return CreateProjectRequest(
      title: form.title.trim(),
      description: nonEmpty(form.description),
      ownerId: form.owner.id,
      consultantId: form.consultant.id,
      contractorId: form.contractor.id,
      contractualBudget: nonEmpty(form.contractualBudget),
      estimatedBudget: nonEmpty(form.estimatedBudget),
      brandId: form.sector.id,
      productId: form.region.id,
      sizeMLId: form.projectType.id,
      productionLineId: form.productionLine.id,
      projectCode: nonEmpty(form.projectCode),
      supervisionConsultantId: form.supervisionConsultant.id,
      supervisionEngineerId: form.supervisionEngineer.id,
      civilEngineerId: form.civilEngineer.id,
      architecturalEngineerId: form.architecturalEngineer.id,
      electricalEngineerId: form.electricalEngineer.id,
      mechanicalEngineerId: form.mechanicalEngineer.id,
      surveyEngineerId: form.surveyEngineer.id,
      agriculturalEngineerId: form.agriculturalEngineer.id,
      generalEngineerId: form.generalEngineer.id,
      projectManagementConsultantId: form.projectManagementConsultant.id,
      architecturalOfficerId: form.architecturalOfficer.id,
      mechanicalOfficerId: form.mechanicalOfficer.id,
      electricalOfficerId: form.electricalOfficer.id,
      subcontractorAdoptionId: form.subcontractorAdoption.id,
      receiveBusinessId: form.receiveBusiness.id,
      documentsAdoptionId: form.documentsAdoption.id,
      executiveBoardsAdoptionId: form.executiveBoardsAdoption.id,
      materialsAdoptionId: form.materialsAdoption.id,
      materialsReceiveAndInspectId: form.materialsReceiveAndInspect.id,
      informationRequestId: form.informationRequest.id,
      paymentCertificateAdoptionId: form.paymentCertificateAdoption.id,
      siteWorkInstructionsId: form.siteWorkInstructions.id,
      siteObservationReportId: form.siteObservationReport.id,
      nonConformanceReportId: form.nonConformanceReport.id,
      startDate: formatDate(form.startDate),
    );
  }
}

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/permissions/permission_cubit.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/utils/enums.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../data/models/create_project_request_models.dart';
import '../../data/models/project_request_item_models.dart';
import '../../domain/repositories/quality_repository.dart';
import '../constants/quality_form_options.dart';
import '../cubit/quality_management_cubit.dart';
import '../widgets/create_request/adoption_items_form_section.dart';
import '../widgets/create_request/create_quality_common_fields_section.dart';
import '../widgets/create_request/create_quality_form_actions.dart';
import '../widgets/create_request/create_quality_form_decoration.dart';
import '../widgets/create_request/executive_board_adoptions_form_section.dart';
import '../widgets/create_request/information_request_form_section.dart';
import '../widgets/create_request/materials_adoption_form_section.dart';
import '../widgets/create_request/materials_receive_inspect_form_section.dart';
import '../widgets/create_request/receive_business_form_section.dart';
import '../widgets/create_request/subcontractor_adoption_form_section.dart';
import '../widgets/create_request/supervision_request_form_section.dart';

class CreateQualityRequestScreen extends StatelessWidget {
  const CreateQualityRequestScreen({super.key});

  static Route<ProjectRequestItem?> route() {
    return MaterialPageRoute<ProjectRequestItem?>(
      builder: (_) => const CreateQualityRequestScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QualityManagementCubit>()..resetCreateState(),
      child: const _CreateQualityRequestView(),
    );
  }
}

class _CreateQualityRequestView extends StatefulWidget {
  const _CreateQualityRequestView();

  @override
  State<_CreateQualityRequestView> createState() =>
      _CreateQualityRequestViewState();
}

class _CreateQualityRequestViewState extends State<_CreateQualityRequestView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _correctiveActionController = TextEditingController();
  final _consultantNotesCorrectiveController = TextEditingController();
  final _consultantNotesReceiptController = TextEditingController();
  final _consultantRequestTypeController = TextEditingController();
  final _buildingStatementController = TextEditingController();
  final _buildingCommentsController = TextEditingController();
  final _floorStatementController = TextEditingController();
  final _floorCommentsController = TextEditingController();
  final _approvedPlatesStatementController = TextEditingController();
  final _approvedPlatesCommentsController = TextEditingController();
  final _requiredExaminationDateCommentsController = TextEditingController();
  final _workToBeExaminedStatementController = TextEditingController();
  final _workToBeExaminedCommentsController = TextEditingController();
  final _responsibleEngineerController = TextEditingController();
  final _responsibleDirectorController = TextEditingController();
  final _approvalApplicationNumberController = TextEditingController();
  final _factoryNameController = TextEditingController();
  final _materialDescriptionController = TextEditingController();
  final _attachmentsStatementController = TextEditingController();
  final _responsibleEngineerNameController = TextEditingController();
  final _responsibleDirectorNameController = TextEditingController();
  final _subcontractorNameController = TextEditingController();
  final _subcontractorEmploymentController = TextEditingController();
  final _subcontractorExperienceController = TextEditingController();
  final _subcontractorExperienceInsideKsaController = TextEditingController();
  final _communicationResponsibleController = TextEditingController();
  final _communicationResponsiblePhoneNumberController = TextEditingController();
  final _subcontractorEmploymentInsideThisProjectController =
      TextEditingController();
  final _otherLicensesController = TextEditingController();
  final _subcontractorLocationController = TextEditingController();
  final _informationRequestSubjectController = TextEditingController();
  final _informationRequestDetailsController = TextEditingController();
  final _materialsAdoptSpecificationsController = TextEditingController();
  final _materialsAdoptSpecificEquipmentController = TextEditingController();
  final _materialsAdoptSuggestedEquipmentController = TextEditingController();
  final _materialsAdoptFactoryController = TextEditingController();
  final _materialsAdoptAlternativeController = TextEditingController();
  final _materialsAdoptCommentsController = TextEditingController();
  final _materialsAdoptOtherMaterialsController = TextEditingController();
  final List<SupervisionProcedureFields> _procedures = [
    SupervisionProcedureFields(),
  ];
  final List<AdoptionItemFields> _adoptionItems = [AdoptionItemFields()];
  final List<ExecutiveBoardAdoptionFields> _executiveBoardItems = [
    ExecutiveBoardAdoptionFields(),
  ];
  final List<RequestedInformationFields> _requestedInformations = [
    RequestedInformationFields(),
  ];

  String? _projectId;
  String? _projectName;
  int _specialization = 0;
  late int _requestType;
  bool _showValidationErrors = false;
  DateTime? _receiveRequiredExaminationDate;
  DateTime? _materialsAccreditationDate;
  DateTime? _materialsRequiredExaminationDate;
  String? _approvalApplicationNumberAttachmentPath;
  String? _factoryNameAttachmentPath;
  String? _attachmentsStatementAttachmentPath;
  String? _commercialLicenseAttachmentPath;
  String? _companyProfileAndCatalogsAttachmentPath;
  String? _generalAuthorityForInvestmentCertificateAttachmentPath;
  String? _vatRegistrationCertificateAttachmentPath;
  String? _validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath;
  String? _validIndustrialOrCommercialLicenseAttachmentPath;
  String? _validSaudizationCertificateAttachmentPath;
  String? _validSocialInsuranceCertificateAttachmentPath;
  String? _conformityStatementAttachmentPath;
  String? _copyOfSpecificationAttachmentPath;
  String? _sampleAttachmentPath;

  @override
  void initState() {
    super.initState();
    final profile = context.read<PermissionCubit>().state;
    _requestType = QualityRequestTypePolicy.defaultTypeFor(profile);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _correctiveActionController.dispose();
    _consultantNotesCorrectiveController.dispose();
    _consultantNotesReceiptController.dispose();
    _consultantRequestTypeController.dispose();
    _buildingStatementController.dispose();
    _buildingCommentsController.dispose();
    _floorStatementController.dispose();
    _floorCommentsController.dispose();
    _approvedPlatesStatementController.dispose();
    _approvedPlatesCommentsController.dispose();
    _requiredExaminationDateCommentsController.dispose();
    _workToBeExaminedStatementController.dispose();
    _workToBeExaminedCommentsController.dispose();
    _responsibleEngineerController.dispose();
    _responsibleDirectorController.dispose();
    _approvalApplicationNumberController.dispose();
    _factoryNameController.dispose();
    _materialDescriptionController.dispose();
    _attachmentsStatementController.dispose();
    _responsibleEngineerNameController.dispose();
    _responsibleDirectorNameController.dispose();
    _subcontractorNameController.dispose();
    _subcontractorEmploymentController.dispose();
    _subcontractorExperienceController.dispose();
    _subcontractorExperienceInsideKsaController.dispose();
    _communicationResponsibleController.dispose();
    _communicationResponsiblePhoneNumberController.dispose();
    _subcontractorEmploymentInsideThisProjectController.dispose();
    _otherLicensesController.dispose();
    _subcontractorLocationController.dispose();
    _informationRequestSubjectController.dispose();
    _informationRequestDetailsController.dispose();
    _materialsAdoptSpecificationsController.dispose();
    _materialsAdoptSpecificEquipmentController.dispose();
    _materialsAdoptSuggestedEquipmentController.dispose();
    _materialsAdoptFactoryController.dispose();
    _materialsAdoptAlternativeController.dispose();
    _materialsAdoptCommentsController.dispose();
    _materialsAdoptOtherMaterialsController.dispose();
    for (final item in _adoptionItems) {
      item.dispose();
    }
    for (final item in _executiveBoardItems) {
      item.dispose();
    }
    for (final item in _requestedInformations) {
      item.dispose();
    }
    for (final procedure in _procedures) {
      procedure.dispose();
    }
    super.dispose();
  }

  QualityManagementCubit get _cubit => context.read<QualityManagementCubit>();

  InputDecoration _inputDecoration(String label) =>
      createQualityInputDecoration(context, label);

  void _refreshNumbers() {
    if (_projectId == null || _projectId!.isEmpty) return;
    _cubit.loadInsertNumbers(
      projectId: _projectId!,
      requestType: _requestType,
      specialization: _specialization,
    );
  }

  Future<List<DropdownMenuItem<String>>> _loadProjects() async {
    final result = await sl<QualityRepository>().getProjects();
    return result.fold(
      (_) => const [],
      (projects) => projects
          .map(
            (ProjectDxItemDto project) => DropdownMenuItem<String>(
              value: project.id,
              child: Text(
                project.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
    );
  }

  List<AdoptionItemInput> _buildAdoptionItemsPayload() {
    return _adoptionItems
        .map(
          (item) => AdoptionItemInput(
            documentDescription: item.descriptionController.text,
            documentReviewNumber: item.reviewNumberController.text,
            numberOfCopies: item.numberOfCopiesController.text,
            recordType: item.recordTypeController.text,
            attachmentPath: item.attachmentPath,
          ),
        )
        .where(
          (item) =>
              item.documentDescription.trim().isNotEmpty ||
              item.documentReviewNumber.trim().isNotEmpty ||
              item.numberOfCopies.trim().isNotEmpty ||
              item.recordType.trim().isNotEmpty ||
              item.hasAttachment,
        )
        .toList();
  }

  List<ExecutiveBoardAdoptionItemInput> _buildExecutiveBoardItemsPayload() {
    return _executiveBoardItems
        .map(
          (item) => ExecutiveBoardAdoptionItemInput(
            plateNumber: item.plateNumberController.text,
            reviewNumber: item.reviewNumberController.text,
            description: item.descriptionController.text,
            attachmentPath: item.attachmentPath,
          ),
        )
        .where(
          (item) =>
              item.plateNumber.trim().isNotEmpty ||
              item.reviewNumber.trim().isNotEmpty ||
              item.description.trim().isNotEmpty ||
              item.hasAttachment,
        )
        .toList();
  }

  InformationRequestInput? _buildInformationRequestPayload() {
    final requestedItems = _requestedInformations
        .map(
          (item) => RequestedInformationItemInput(
            description: item.descriptionController.text,
            attachmentPath: item.attachmentPath,
          ),
        )
        .where(
          (item) =>
              item.description.trim().isNotEmpty || item.hasAttachment,
        )
        .toList();

    return InformationRequestInput(
      subject: _informationRequestSubjectController.text,
      details: _informationRequestDetailsController.text,
      requestedInformations: requestedItems,
    );
  }

  ({
    String sectionTitleKey,
    String itemIndexKey,
    String addButtonKey,
  }) _adoptionFormConfig() {
    if (_requestType == 8) {
      return (
        sectionTitleKey: AppString.paymentCertificateAdoptionDetails,
        itemIndexKey: AppString.documentIndex,
        addButtonKey: AppString.addDocument,
      );
    }
    return (
      sectionTitleKey: AppString.documentsAdoptionDetails,
      itemIndexKey: AppString.documentIndex,
      addButtonKey: AppString.addDocument,
    );
  }

  Future<void> _submit(QualityManagementState state) async {
    setState(() => _showValidationErrors = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_projectId == null || state.serialNumber == null) {
      AppFunctions.showsToast(
        AppString.fillRequiredFields.tr(),
        AppColor.kRedColor,
        context,
      );
      return;
    }

    final payload = CreateProjectRequestPayload(
      serialNumber: state.serialNumber!,
      reviewNumber: state.reviewNumber ?? 0,
      requestDate: DateTime.now(),
      projectId: _projectId!,
      specialization: _specialization,
      requestType: _requestType,
      description: _descriptionController.text,
      correctiveAction: _correctiveActionController.text,
      consultantNotesOnCorrectiveAction:
          _consultantNotesCorrectiveController.text,
      consultantNotesForReceiptOfWorks: _consultantNotesReceiptController.text,
      consultantRequestType: _consultantRequestTypeController.text,
      procedures: _procedures
          .map(
            (procedure) => SupervisionProcedureInput(
              title: procedure.titleController.text,
              description: procedure.descriptionController.text,
            ),
          )
          .where(
            (procedure) =>
                procedure.title.trim().isNotEmpty ||
                procedure.description.trim().isNotEmpty,
          )
          .toList(),
      receiveBusiness: QualityCreatableRequestTypes.usesReceiveBusinessForm(
              _requestType)
          ? ReceiveBusinessInput(
              buildingStatement: _buildingStatementController.text,
              buildingComments: _buildingCommentsController.text,
              floorStatement: _floorStatementController.text,
              floorComments: _floorCommentsController.text,
              approvedPlatesStatement: _approvedPlatesStatementController.text,
              approvedPlatesComments: _approvedPlatesCommentsController.text,
              requiredExaminationDateStatement: _receiveRequiredExaminationDate,
              requiredExaminationDateComments:
                  _requiredExaminationDateCommentsController.text,
              workToBeExaminedStatement:
                  _workToBeExaminedStatementController.text,
              workToBeExaminedComments: _workToBeExaminedCommentsController.text,
              responsibleEngineer: _responsibleEngineerController.text,
              responsibleDirector: _responsibleDirectorController.text,
            )
          : null,
      materialsReceiveAndInspect:
          QualityCreatableRequestTypes.usesMaterialsReceiveForm(_requestType)
              ? MaterialsReceiveAndInspectInput(
                  approvalApplicationNumber:
                      _approvalApplicationNumberController.text,
                  accreditationDate: _materialsAccreditationDate,
                  factoryName: _factoryNameController.text,
                  requiredExaminationDate: _materialsRequiredExaminationDate,
                  materialDescription: _materialDescriptionController.text,
                  attachmentsStatement: _attachmentsStatementController.text,
                  responsibleEngineerName:
                      _responsibleEngineerNameController.text,
                  responsibleDirectorName:
                      _responsibleDirectorNameController.text,
                  approvalApplicationNumberAttachmentPath:
                      _approvalApplicationNumberAttachmentPath,
                  factoryNameAttachmentPath: _factoryNameAttachmentPath,
                  attachmentsStatementAttachmentPath:
                      _attachmentsStatementAttachmentPath,
                )
              : null,
      adoptionItems:
          QualityCreatableRequestTypes.usesAdoptionItemsForm(_requestType)
              ? _buildAdoptionItemsPayload()
              : const [],
      subcontractorAdoption:
          QualityCreatableRequestTypes.usesSubcontractorAdoptionForm(
                  _requestType)
              ? SubcontractorAdoptionInput(
                  subcontractorName: _subcontractorNameController.text,
                  subcontractorEmployment:
                      _subcontractorEmploymentController.text,
                  subcontractorExperience:
                      _subcontractorExperienceController.text,
                  subcontractorExperienceInsideKsa:
                      _subcontractorExperienceInsideKsaController.text,
                  communicationResponsible:
                      _communicationResponsibleController.text,
                  communicationResponsiblePhoneNumber:
                      _communicationResponsiblePhoneNumberController.text,
                  subcontractorEmploymentInsideThisProject:
                      _subcontractorEmploymentInsideThisProjectController.text,
                  otherLicenses: _otherLicensesController.text,
                  subcontractorLocation: _subcontractorLocationController.text,
                  commercialLicenseAttachmentPath:
                      _commercialLicenseAttachmentPath,
                  companyProfileAndCatalogsAttachmentPath:
                      _companyProfileAndCatalogsAttachmentPath,
                  generalAuthorityForInvestmentCertificateAttachmentPath:
                      _generalAuthorityForInvestmentCertificateAttachmentPath,
                  vatRegistrationCertificateAttachmentPath:
                      _vatRegistrationCertificateAttachmentPath,
                  validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath:
                      _validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath,
                  validIndustrialOrCommercialLicenseAttachmentPath:
                      _validIndustrialOrCommercialLicenseAttachmentPath,
                  validSaudizationCertificateAttachmentPath:
                      _validSaudizationCertificateAttachmentPath,
                  validSocialInsuranceCertificateAttachmentPath:
                      _validSocialInsuranceCertificateAttachmentPath,
                )
              : null,
      executiveBoardAdoptions:
          QualityCreatableRequestTypes.usesExecutiveBoardAdoptionForm(
                  _requestType)
              ? _buildExecutiveBoardItemsPayload()
              : const [],
      informationRequest:
          QualityCreatableRequestTypes.usesInformationRequestForm(_requestType)
              ? _buildInformationRequestPayload()
              : null,
      materialsAdoption:
          QualityCreatableRequestTypes.usesMaterialsAdoptionForm(_requestType)
              ? MaterialsAdoptionInput(
                  specifications: _materialsAdoptSpecificationsController.text,
                  specificEquipment:
                      _materialsAdoptSpecificEquipmentController.text,
                  suggestedEquipment:
                      _materialsAdoptSuggestedEquipmentController.text,
                  factory: _materialsAdoptFactoryController.text,
                  alternative: _materialsAdoptAlternativeController.text,
                  comments: _materialsAdoptCommentsController.text,
                  otherMaterials: _materialsAdoptOtherMaterialsController.text,
                  conformityStatementAttachmentPath:
                      _conformityStatementAttachmentPath,
                  copyOfSpecificationAttachmentPath:
                      _copyOfSpecificationAttachmentPath,
                  sampleAttachmentPath: _sampleAttachmentPath,
                )
              : null,
    );

    final created = await _cubit.submitCreateRequest(
      payload,
      projectName: _projectName ?? '',
    );

    if (!mounted) return;
    if (created == null) {
      final error = _cubit.state.createError.trim();
      AppFunctions.showsToast(
        error.isNotEmpty ? error.tr() : AppString.unKnownError.tr(),
        AppColor.kRedColor,
        context,
      );
      return;
    }

    AppFunctions.showSuccessToast(
      context,
      AppString.requestCreatedSuccessfully.tr(),
    );
    Navigator.pop(context, created);
  }

  String? _pathOrNull(String path) => path.isEmpty ? null : path;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final profile = context.watch<PermissionCubit>().state;
    final allowedRequestTypes = QualityRequestTypePolicy.allowedFor(profile);
    final allowedValues = allowedRequestTypes.map((e) => e.value).toList();
    if (!allowedValues.contains(_requestType) && allowedValues.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _requestType = allowedValues.first);
        _refreshNumbers();
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: colors.kBgColor,
        appBar: AppBar(
          backgroundColor: colors.kBgColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: colors.kFontColor),
          title: Text(
            AppString.createRequest.tr(),
            style: TextStyle(
              color: colors.kPrimaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
            ),
          ),
        ),
        body: BlocBuilder<QualityManagementCubit, QualityManagementState>(
          builder: (context, state) {
            final isLoadingNumbers =
                state.createNumbersStatus == RequestStatus.loading;
            final isSubmitting =
                state.createSubmitStatus == RequestStatus.loading;

            return Form(
              key: _formKey,
              autovalidateMode: _showValidationErrors
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                children: [
                  CreateQualityCommonFieldsSection(
                    projectId: _projectId,
                    projectName: _projectName,
                    specialization: _specialization,
                    requestType: _requestType,
                    allowedRequestTypes: allowedRequestTypes,
                    showValidationErrors: _showValidationErrors,
                    isLoadingNumbers: isLoadingNumbers,
                    serialNumber: state.serialNumber,
                    reviewNumber: state.reviewNumber,
                    loadProjects: _loadProjects,
                    onProjectSelected: (id, label) {
                      setState(() {
                        _projectId = id;
                        _projectName = label;
                      });
                      _refreshNumbers();
                    },
                    onSpecializationChanged: (value) {
                      setState(() => _specialization = value);
                      _refreshNumbers();
                    },
                    onRequestTypeChanged: (value) {
                      setState(() => _requestType = value);
                      _refreshNumbers();
                    },
                  ),
                  if (QualityCreatableRequestTypes.usesReceiveBusinessForm(
                    _requestType,
                  )) ...[
                    SizedBox(height: 20.h),
                    ReceiveBusinessFormSection(
                      buildingStatementController: _buildingStatementController,
                      buildingCommentsController: _buildingCommentsController,
                      floorStatementController: _floorStatementController,
                      floorCommentsController: _floorCommentsController,
                      approvedPlatesStatementController:
                          _approvedPlatesStatementController,
                      approvedPlatesCommentsController:
                          _approvedPlatesCommentsController,
                      requiredExaminationDateCommentsController:
                          _requiredExaminationDateCommentsController,
                      workToBeExaminedStatementController:
                          _workToBeExaminedStatementController,
                      workToBeExaminedCommentsController:
                          _workToBeExaminedCommentsController,
                      responsibleEngineerController:
                          _responsibleEngineerController,
                      responsibleDirectorController:
                          _responsibleDirectorController,
                      requiredExaminationDate: _receiveRequiredExaminationDate,
                      onRequiredExaminationDateChanged: (date) {
                        setState(
                          () => _receiveRequiredExaminationDate = date,
                        );
                      },
                      inputDecoration: _inputDecoration,
                    ),
                  ],
                  if (QualityCreatableRequestTypes.usesAdoptionItemsForm(
                    _requestType,
                  )) ...[
                    SizedBox(height: 20.h),
                    Builder(
                      builder: (context) {
                        final config = _adoptionFormConfig();
                        return AdoptionItemsFormSection(
                          items: _adoptionItems,
                          sectionTitleKey: config.sectionTitleKey,
                          itemIndexKey: config.itemIndexKey,
                          addButtonKey: config.addButtonKey,
                          onAdd: () {
                            setState(
                              () => _adoptionItems.add(AdoptionItemFields()),
                            );
                          },
                          onDelete: (index) {
                            setState(() {
                              _adoptionItems[index].dispose();
                              _adoptionItems.removeAt(index);
                            });
                          },
                          onAttachmentPicked: (index, path) {
                            setState(() {
                              _adoptionItems[index].attachmentPath =
                                  _pathOrNull(path);
                            });
                          },
                          inputDecoration: _inputDecoration,
                        );
                      },
                    ),
                  ],
                  if (QualityCreatableRequestTypes.usesMaterialsAdoptionForm(
                    _requestType,
                  )) ...[
                    SizedBox(height: 20.h),
                    MaterialsAdoptionFormSection(
                      specificationsController:
                          _materialsAdoptSpecificationsController,
                      specificEquipmentController:
                          _materialsAdoptSpecificEquipmentController,
                      suggestedEquipmentController:
                          _materialsAdoptSuggestedEquipmentController,
                      factoryController: _materialsAdoptFactoryController,
                      alternativeController:
                          _materialsAdoptAlternativeController,
                      commentsController: _materialsAdoptCommentsController,
                      otherMaterialsController:
                          _materialsAdoptOtherMaterialsController,
                      conformityStatementAttachmentPath:
                          _conformityStatementAttachmentPath,
                      copyOfSpecificationAttachmentPath:
                          _copyOfSpecificationAttachmentPath,
                      sampleAttachmentPath: _sampleAttachmentPath,
                      onConformityStatementAttachmentPicked: (path) {
                        setState(() {
                          _conformityStatementAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onCopyOfSpecificationAttachmentPicked: (path) {
                        setState(() {
                          _copyOfSpecificationAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onSampleAttachmentPicked: (path) {
                        setState(() {
                          _sampleAttachmentPath = _pathOrNull(path);
                        });
                      },
                      inputDecoration: _inputDecoration,
                    ),
                  ],
                  if (QualityCreatableRequestTypes
                      .usesExecutiveBoardAdoptionForm(_requestType)) ...[
                    SizedBox(height: 20.h),
                    ExecutiveBoardAdoptionsFormSection(
                      items: _executiveBoardItems,
                      onAdd: () {
                        setState(
                          () => _executiveBoardItems
                              .add(ExecutiveBoardAdoptionFields()),
                        );
                      },
                      onDelete: (index) {
                        setState(() {
                          _executiveBoardItems[index].dispose();
                          _executiveBoardItems.removeAt(index);
                        });
                      },
                      onAttachmentPicked: (index, path) {
                        setState(() {
                          _executiveBoardItems[index].attachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      inputDecoration: _inputDecoration,
                    ),
                  ],
                  if (QualityCreatableRequestTypes
                      .usesSubcontractorAdoptionForm(_requestType)) ...[
                    SizedBox(height: 20.h),
                    SubcontractorAdoptionFormSection(
                      subcontractorNameController: _subcontractorNameController,
                      subcontractorEmploymentController:
                          _subcontractorEmploymentController,
                      subcontractorExperienceController:
                          _subcontractorExperienceController,
                      subcontractorExperienceInsideKsaController:
                          _subcontractorExperienceInsideKsaController,
                      communicationResponsibleController:
                          _communicationResponsibleController,
                      communicationResponsiblePhoneNumberController:
                          _communicationResponsiblePhoneNumberController,
                      subcontractorEmploymentInsideThisProjectController:
                          _subcontractorEmploymentInsideThisProjectController,
                      otherLicensesController: _otherLicensesController,
                      subcontractorLocationController:
                          _subcontractorLocationController,
                      commercialLicenseAttachmentPath:
                          _commercialLicenseAttachmentPath,
                      companyProfileAndCatalogsAttachmentPath:
                          _companyProfileAndCatalogsAttachmentPath,
                      generalAuthorityForInvestmentCertificateAttachmentPath:
                          _generalAuthorityForInvestmentCertificateAttachmentPath,
                      vatRegistrationCertificateAttachmentPath:
                          _vatRegistrationCertificateAttachmentPath,
                      validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath:
                          _validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath,
                      validIndustrialOrCommercialLicenseAttachmentPath:
                          _validIndustrialOrCommercialLicenseAttachmentPath,
                      validSaudizationCertificateAttachmentPath:
                          _validSaudizationCertificateAttachmentPath,
                      validSocialInsuranceCertificateAttachmentPath:
                          _validSocialInsuranceCertificateAttachmentPath,
                      onCommercialLicenseAttachmentPicked: (path) {
                        setState(() {
                          _commercialLicenseAttachmentPath = _pathOrNull(path);
                        });
                      },
                      onCompanyProfileAndCatalogsAttachmentPicked: (path) {
                        setState(() {
                          _companyProfileAndCatalogsAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onGeneralAuthorityForInvestmentCertificateAttachmentPicked:
                          (path) {
                        setState(() {
                          _generalAuthorityForInvestmentCertificateAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onVatRegistrationCertificateAttachmentPicked: (path) {
                        setState(() {
                          _vatRegistrationCertificateAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onValidGeneralAuthorityForZakatAndTaxCertificateAttachmentPicked:
                          (path) {
                        setState(() {
                          _validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onValidIndustrialOrCommercialLicenseAttachmentPicked:
                          (path) {
                        setState(() {
                          _validIndustrialOrCommercialLicenseAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onValidSaudizationCertificateAttachmentPicked: (path) {
                        setState(() {
                          _validSaudizationCertificateAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onValidSocialInsuranceCertificateAttachmentPicked:
                          (path) {
                        setState(() {
                          _validSocialInsuranceCertificateAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      inputDecoration: _inputDecoration,
                    ),
                  ],
                  if (QualityCreatableRequestTypes.usesInformationRequestForm(
                    _requestType,
                  )) ...[
                    SizedBox(height: 20.h),
                    InformationRequestFormSection(
                      subjectController: _informationRequestSubjectController,
                      detailsController: _informationRequestDetailsController,
                      requestedInformations: _requestedInformations,
                      onAdd: () {
                        setState(
                          () => _requestedInformations
                              .add(RequestedInformationFields()),
                        );
                      },
                      onDelete: (index) {
                        setState(() {
                          _requestedInformations[index].dispose();
                          _requestedInformations.removeAt(index);
                        });
                      },
                      onAttachmentPicked: (index, path) {
                        setState(() {
                          _requestedInformations[index].attachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      inputDecoration: _inputDecoration,
                    ),
                  ],
                  if (QualityCreatableRequestTypes.usesMaterialsReceiveForm(
                    _requestType,
                  )) ...[
                    SizedBox(height: 20.h),
                    MaterialsReceiveInspectFormSection(
                      approvalApplicationNumberController:
                          _approvalApplicationNumberController,
                      factoryNameController: _factoryNameController,
                      materialDescriptionController:
                          _materialDescriptionController,
                      attachmentsStatementController:
                          _attachmentsStatementController,
                      responsibleEngineerNameController:
                          _responsibleEngineerNameController,
                      responsibleDirectorNameController:
                          _responsibleDirectorNameController,
                      accreditationDate: _materialsAccreditationDate,
                      requiredExaminationDate:
                          _materialsRequiredExaminationDate,
                      onAccreditationDateChanged: (date) {
                        setState(() => _materialsAccreditationDate = date);
                      },
                      onRequiredExaminationDateChanged: (date) {
                        setState(
                          () => _materialsRequiredExaminationDate = date,
                        );
                      },
                      approvalApplicationNumberAttachmentPath:
                          _approvalApplicationNumberAttachmentPath,
                      factoryNameAttachmentPath: _factoryNameAttachmentPath,
                      attachmentsStatementAttachmentPath:
                          _attachmentsStatementAttachmentPath,
                      onApprovalApplicationNumberAttachmentPicked: (path) {
                        setState(() {
                          _approvalApplicationNumberAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      onFactoryNameAttachmentPicked: (path) {
                        setState(() {
                          _factoryNameAttachmentPath = _pathOrNull(path);
                        });
                      },
                      onAttachmentsStatementAttachmentPicked: (path) {
                        setState(() {
                          _attachmentsStatementAttachmentPath =
                              _pathOrNull(path);
                        });
                      },
                      inputDecoration: _inputDecoration,
                    ),
                  ],
                  if (QualityCreatableRequestTypes.usesSupervisionForm(
                    _requestType,
                  )) ...[
                    SizedBox(height: 20.h),
                    SupervisionRequestFormSection(
                      requestType: _requestType,
                      descriptionController: _descriptionController,
                      correctiveActionController: _correctiveActionController,
                      consultantNotesCorrectiveController:
                          _consultantNotesCorrectiveController,
                      consultantNotesReceiptController:
                          _consultantNotesReceiptController,
                      consultantRequestTypeController:
                          _consultantRequestTypeController,
                      procedures: _procedures,
                      onAddProcedure: () {
                        setState(
                          () => _procedures.add(SupervisionProcedureFields()),
                        );
                      },
                      onDeleteProcedure: (index) {
                        setState(() {
                          _procedures[index].dispose();
                          _procedures.removeAt(index);
                        });
                      },
                      inputDecoration: _inputDecoration,
                    ),
                  ],
                  SizedBox(height: 24.h),
                  CreateQualityFormActions(
                    isSubmitting: isSubmitting,
                    onCancel: () => Navigator.pop(context),
                    onSubmit: () => _submit(state),
                  ),  SizedBox(height: 24.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

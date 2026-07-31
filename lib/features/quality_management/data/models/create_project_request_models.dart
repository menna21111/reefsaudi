import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ProjectRequestInsertNumbers {
  const ProjectRequestInsertNumbers({
    required this.serialNumber,
    required this.reviewNumber,
  });

  final int serialNumber;
  final int reviewNumber;

  factory ProjectRequestInsertNumbers.fromJson(Map<String, dynamic> json) {
    return ProjectRequestInsertNumbers(
      serialNumber: _toInt(json['serialNumber']),
      reviewNumber: _toInt(json['reviewNumber']),
    );
  }
}

class SupervisionProcedureInput {
  const SupervisionProcedureInput({
    this.title = '',
    this.description = '',
  });

  final String title;
  final String description;
}

class ReceiveBusinessInput {
  const ReceiveBusinessInput({
    this.buildingStatement = '',
    this.buildingComments = '',
    this.floorStatement = '',
    this.floorComments = '',
    this.approvedPlatesStatement = '',
    this.approvedPlatesComments = '',
    this.requiredExaminationDateStatement,
    this.requiredExaminationDateComments = '',
    this.workToBeExaminedStatement = '',
    this.workToBeExaminedComments = '',
    this.responsibleEngineer = '',
    this.responsibleDirector = '',
  });

  final String buildingStatement;
  final String buildingComments;
  final String floorStatement;
  final String floorComments;
  final String approvedPlatesStatement;
  final String approvedPlatesComments;
  final DateTime? requiredExaminationDateStatement;
  final String requiredExaminationDateComments;
  final String workToBeExaminedStatement;
  final String workToBeExaminedComments;
  final String responsibleEngineer;
  final String responsibleDirector;
}

class MaterialsReceiveAndInspectInput {
  const MaterialsReceiveAndInspectInput({
    this.approvalApplicationNumber = '',
    this.accreditationDate,
    this.factoryName = '',
    this.requiredExaminationDate,
    this.materialDescription = '',
    this.attachmentsStatement = '',
    this.responsibleEngineerName = '',
    this.responsibleDirectorName = '',
    this.approvalApplicationNumberAttachmentPath,
    this.factoryNameAttachmentPath,
    this.attachmentsStatementAttachmentPath,
  });

  final String approvalApplicationNumber;
  final DateTime? accreditationDate;
  final String factoryName;
  final DateTime? requiredExaminationDate;
  final String materialDescription;
  final String attachmentsStatement;
  final String responsibleEngineerName;
  final String responsibleDirectorName;
  final String? approvalApplicationNumberAttachmentPath;
  final String? factoryNameAttachmentPath;
  final String? attachmentsStatementAttachmentPath;

  bool get hasAttachments =>
      approvalApplicationNumberAttachmentPath != null ||
      factoryNameAttachmentPath != null ||
      attachmentsStatementAttachmentPath != null;
}

class AdoptionItemInput {
  const AdoptionItemInput({
    this.documentDescription = '',
    this.documentReviewNumber = '',
    this.numberOfCopies = '',
    this.recordType = '',
    this.attachmentPath,
  });

  final String documentDescription;
  final String documentReviewNumber;
  final String numberOfCopies;
  final String recordType;
  final String? attachmentPath;

  bool get hasAttachment => attachmentPath != null && attachmentPath!.isNotEmpty;
}

class SubcontractorAdoptionInput {
  const SubcontractorAdoptionInput({
    this.subcontractorName = '',
    this.subcontractorEmployment = '',
    this.subcontractorExperience = '',
    this.subcontractorExperienceInsideKsa = '',
    this.communicationResponsible = '',
    this.communicationResponsiblePhoneNumber = '',
    this.subcontractorEmploymentInsideThisProject = '',
    this.otherLicenses = '',
    this.subcontractorLocation = '',
    this.commercialLicenseAttachmentPath,
    this.companyProfileAndCatalogsAttachmentPath,
    this.generalAuthorityForInvestmentCertificateAttachmentPath,
    this.vatRegistrationCertificateAttachmentPath,
    this.validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath,
    this.validIndustrialOrCommercialLicenseAttachmentPath,
    this.validSaudizationCertificateAttachmentPath,
    this.validSocialInsuranceCertificateAttachmentPath,
  });

  final String subcontractorName;
  final String subcontractorEmployment;
  final String subcontractorExperience;
  final String subcontractorExperienceInsideKsa;
  final String communicationResponsible;
  final String communicationResponsiblePhoneNumber;
  final String subcontractorEmploymentInsideThisProject;
  final String otherLicenses;
  final String subcontractorLocation;
  final String? commercialLicenseAttachmentPath;
  final String? companyProfileAndCatalogsAttachmentPath;
  final String? generalAuthorityForInvestmentCertificateAttachmentPath;
  final String? vatRegistrationCertificateAttachmentPath;
  final String? validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath;
  final String? validIndustrialOrCommercialLicenseAttachmentPath;
  final String? validSaudizationCertificateAttachmentPath;
  final String? validSocialInsuranceCertificateAttachmentPath;

  bool get hasAttachments =>
      commercialLicenseAttachmentPath != null ||
      companyProfileAndCatalogsAttachmentPath != null ||
      generalAuthorityForInvestmentCertificateAttachmentPath != null ||
      vatRegistrationCertificateAttachmentPath != null ||
      validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath != null ||
      validIndustrialOrCommercialLicenseAttachmentPath != null ||
      validSaudizationCertificateAttachmentPath != null ||
      validSocialInsuranceCertificateAttachmentPath != null;
}

class ExecutiveBoardAdoptionItemInput {
  const ExecutiveBoardAdoptionItemInput({
    this.plateNumber = '',
    this.reviewNumber = '',
    this.description = '',
    this.attachmentPath,
  });

  final String plateNumber;
  final String reviewNumber;
  final String description;
  final String? attachmentPath;

  bool get hasAttachment => attachmentPath != null && attachmentPath!.isNotEmpty;
}

class RequestedInformationItemInput {
  const RequestedInformationItemInput({
    this.description = '',
    this.attachmentPath,
  });

  final String description;
  final String? attachmentPath;

  bool get hasAttachment => attachmentPath != null && attachmentPath!.isNotEmpty;
}

class InformationRequestInput {
  const InformationRequestInput({
    this.subject = '',
    this.details = '',
    this.requestedInformations = const [],
  });

  final String subject;
  final String details;
  final List<RequestedInformationItemInput> requestedInformations;

  bool get hasAttachments =>
      requestedInformations.any((item) => item.hasAttachment);
}

class MaterialsAdoptionInput {
  const MaterialsAdoptionInput({
    this.specifications = '',
    this.specificEquipment = '',
    this.suggestedEquipment = '',
    this.factory = '',
    this.alternative = '',
    this.comments = '',
    this.otherMaterials = '',
    this.conformityStatementAttachmentPath,
    this.copyOfSpecificationAttachmentPath,
    this.sampleAttachmentPath,
  });

  final String specifications;
  final String specificEquipment;
  final String suggestedEquipment;
  final String factory;
  final String alternative;
  final String comments;
  final String otherMaterials;
  final String? conformityStatementAttachmentPath;
  final String? copyOfSpecificationAttachmentPath;
  final String? sampleAttachmentPath;

  bool get hasAttachments =>
      conformityStatementAttachmentPath != null ||
      copyOfSpecificationAttachmentPath != null ||
      sampleAttachmentPath != null;
}

class CreateProjectRequestPayload {
  const CreateProjectRequestPayload({
    required this.serialNumber,
    required this.reviewNumber,
    required this.requestDate,
    required this.projectId,
    required this.specialization,
    required this.requestType,
    this.description,
    this.correctiveAction,
    this.consultantNotesOnCorrectiveAction,
    this.consultantNotesForReceiptOfWorks,
    this.consultantRequestType,
    this.procedures = const [],
    this.receiveBusiness,
    this.materialsReceiveAndInspect,
    this.adoptionItems = const [],
    this.subcontractorAdoption,
    this.executiveBoardAdoptions = const [],
    this.informationRequest,
    this.materialsAdoption,
  });

  final int serialNumber;
  final int reviewNumber;
  final DateTime requestDate;
  final String projectId;
  final int specialization;
  final int requestType;
  final String? description;
  final String? correctiveAction;
  final String? consultantNotesOnCorrectiveAction;
  final String? consultantNotesForReceiptOfWorks;
  final String? consultantRequestType;
  final List<SupervisionProcedureInput> procedures;
  final ReceiveBusinessInput? receiveBusiness;
  final MaterialsReceiveAndInspectInput? materialsReceiveAndInspect;
  final List<AdoptionItemInput> adoptionItems;
  final SubcontractorAdoptionInput? subcontractorAdoption;
  final List<ExecutiveBoardAdoptionItemInput> executiveBoardAdoptions;
  final InformationRequestInput? informationRequest;
  final MaterialsAdoptionInput? materialsAdoption;

  static String? adoptionListKey(int requestType) {
    return switch (requestType) {
      1 => 'documentsAdoption',
      8 => 'documentsAdoption',
      _ => null,
    };
  }

  Map<String, dynamic> toFormMap() {
    final map = <String, dynamic>{
      'serialNumber': serialNumber,
      'reviewNumber': reviewNumber,
      'requestDate': _formatRequestDate(requestDate),
      'projectId': projectId,
      'specialization': specialization,
      'requestType': requestType,
    };

    void put(String key, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        map[key] = value.trim();
      }
    }

    void putDate(String key, DateTime? value) {
      if (value != null) {
        map[key] = _formatDateField(value);
      }
    }

    put('supervisionConsultant.Description', description);
    put('supervisionConsultant.CorrectiveAction', correctiveAction);
    put(
      'supervisionConsultant.ConsultantNotesOnTheCorrectiveAction',
      consultantNotesOnCorrectiveAction,
    );
    put(
      'supervisionConsultant.ConsultantNotesForReceiptOfWorks',
      consultantNotesForReceiptOfWorks,
    );
    put('supervisionConsultant.RequestType', consultantRequestType);

    for (var i = 0; i < procedures.length; i++) {
      final procedure = procedures[i];
      put(
        'supervisionConsultant.SupervisionProcedures[$i].Title',
        procedure.title,
      );
      put(
        'supervisionConsultant.SupervisionProcedures[$i].Description',
        procedure.description,
      );
    }

    final receive = receiveBusiness;
    if (receive != null) {
      put('receiveBusiness.buildingStatement', receive.buildingStatement);
      put('receiveBusiness.buildingComments', receive.buildingComments);
      put('receiveBusiness.floorStatement', receive.floorStatement);
      put('receiveBusiness.floorComments', receive.floorComments);
      put(
        'receiveBusiness.approvedPlatesStatement',
        receive.approvedPlatesStatement,
      );
      put(
        'receiveBusiness.approvedPlatesComments',
        receive.approvedPlatesComments,
      );
      putDate(
        'receiveBusiness.requiredExaminationDateStatement',
        receive.requiredExaminationDateStatement,
      );
      put(
        'receiveBusiness.requiredExaminationDateComments',
        receive.requiredExaminationDateComments,
      );
      put(
        'receiveBusiness.workToBeExaminedStatement',
        receive.workToBeExaminedStatement,
      );
      put(
        'receiveBusiness.workToBeExaminedComments',
        receive.workToBeExaminedComments,
      );
      put('receiveBusiness.responsibleEngineer', receive.responsibleEngineer);
      put('receiveBusiness.responsibleDirector', receive.responsibleDirector);
    }

    final materials = materialsReceiveAndInspect;
    if (materials != null) {
      put(
        'materialsReceiveAndInspect.ApprovalApplicationNumber',
        materials.approvalApplicationNumber,
      );
      putDate(
        'materialsReceiveAndInspect.AccreditationDate',
        materials.accreditationDate,
      );
      put('materialsReceiveAndInspect.FactoryName', materials.factoryName);
      putDate(
        'materialsReceiveAndInspect.RequiredExaminationDate',
        materials.requiredExaminationDate,
      );
      put(
        'materialsReceiveAndInspect.MaterialDescription',
        materials.materialDescription,
      );
      put(
        'materialsReceiveAndInspect.AttachmentsStatement',
        materials.attachmentsStatement,
      );
      put(
        'materialsReceiveAndInspect.ResponsibleEngineerName',
        materials.responsibleEngineerName,
      );
      put(
        'materialsReceiveAndInspect.ResponsibleDirectorName',
        materials.responsibleDirectorName,
      );
    }

    final adoptionKey = adoptionListKey(requestType);
    if (adoptionKey != null) {
      for (var i = 0; i < adoptionItems.length; i++) {
        final item = adoptionItems[i];
        put(
          '$adoptionKey[$i].DocumentDescription',
          item.documentDescription,
        );
        put(
          '$adoptionKey[$i].DocumentReviewNumber',
          item.documentReviewNumber,
        );
        put('$adoptionKey[$i].NumberOfCopies', item.numberOfCopies);
        put('$adoptionKey[$i].RecordType', item.recordType);
      }
    }

    final subcontractor = subcontractorAdoption;
    if (subcontractor != null) {
      put(
        'subcontractorAdoption.SubcontractorName',
        subcontractor.subcontractorName,
      );
      put(
        'subcontractorAdoption.SubcontractorEmployment',
        subcontractor.subcontractorEmployment,
      );
      put(
        'subcontractorAdoption.SubcontractorExperience',
        subcontractor.subcontractorExperience,
      );
      put(
        'subcontractorAdoption.SubcontractorExperienceinsideksa',
        subcontractor.subcontractorExperienceInsideKsa,
      );
      put(
        'subcontractorAdoption.CommunicationResponsible',
        subcontractor.communicationResponsible,
      );
      put(
        'subcontractorAdoption.CommunicationResponsiblePhoneNumber',
        subcontractor.communicationResponsiblePhoneNumber,
      );
      put(
        'subcontractorAdoption.SubcontractorEmploymentinsidethisproject',
        subcontractor.subcontractorEmploymentInsideThisProject,
      );
      put(
        'subcontractorAdoption.OtherLicenses',
        subcontractor.otherLicenses,
      );
      put(
        'subcontractorAdoption.SubcontractorLocation',
        subcontractor.subcontractorLocation,
      );
    }

    for (var i = 0; i < executiveBoardAdoptions.length; i++) {
      final board = executiveBoardAdoptions[i];
      put('executiveBoardAdoptions[$i].PlateNumber', board.plateNumber);
      put('executiveBoardAdoptions[$i].ReviewNumber', board.reviewNumber);
      put('executiveBoardAdoptions[$i].Description', board.description);
    }

    final information = informationRequest;
    if (information != null) {
      put('informationRequest.Subject', information.subject);
      put('informationRequest.Details', information.details);
      for (var i = 0; i < information.requestedInformations.length; i++) {
        final item = information.requestedInformations[i];
        put(
          'informationRequest.RequestedInformations[$i].Description',
          item.description,
        );
      }
    }

    final materialsAdopt = materialsAdoption;
    if (materialsAdopt != null) {
      put('materialsAdoption.Specifications', materialsAdopt.specifications);
      put(
        'materialsAdoption.SpecificEquipment',
        materialsAdopt.specificEquipment,
      );
      put(
        'materialsAdoption.SuggestedEquipment',
        materialsAdopt.suggestedEquipment,
      );
      put('materialsAdoption.Factory', materialsAdopt.factory);
      put('materialsAdoption.Alternative', materialsAdopt.alternative);
      put('materialsAdoption.Comments', materialsAdopt.comments);
      put('materialsAdoption.OtherMaterials', materialsAdopt.otherMaterials);
    }

    return map;
  }

  Future<FormData> toFormData() async {
    final map = toFormMap();

    Future<void> putMultipart(String key, String? path) async {
      if (path == null || path.isEmpty) return;
      map[key] = await multipartFromLocalPath(path);
    }

    final materials = materialsReceiveAndInspect;

    if (materials != null) {
      await putMultipart(
        'materialsReceiveAndInspect.ApprovalApplicationNumberAttachment',
        materials.approvalApplicationNumberAttachmentPath,
      );
      await putMultipart(
        'materialsReceiveAndInspect.FactoryNameAttachment',
        materials.factoryNameAttachmentPath,
      );
      await putMultipart(
        'materialsReceiveAndInspect.AttachmentsStatementAttachment',
        materials.attachmentsStatementAttachmentPath,
      );
    }

    final adoptionKey = adoptionListKey(requestType);
    if (adoptionKey != null) {
      for (var i = 0; i < adoptionItems.length; i++) {
        await putMultipart(
          '$adoptionKey[$i].Attachment',
          adoptionItems[i].attachmentPath,
        );
      }
    }

    final subcontractor = subcontractorAdoption;
    if (subcontractor != null) {
      Future<void> putFile(String key, String? path) async {
        await putMultipart(key, path);
      }

      await putFile(
        'subcontractorAdoption.CommercialLicenseAttachment',
        subcontractor.commercialLicenseAttachmentPath,
      );
      await putFile(
        'subcontractorAdoption.CompanyProfileAndCatalogsAttachment',
        subcontractor.companyProfileAndCatalogsAttachmentPath,
      );
      await putFile(
        'subcontractorAdoption.GeneralAuthorityForInvestmentCertificateAttachment',
        subcontractor.generalAuthorityForInvestmentCertificateAttachmentPath,
      );
      await putFile(
        'subcontractorAdoption.VATRegistrationCertificateAttachment',
        subcontractor.vatRegistrationCertificateAttachmentPath,
      );
      await putFile(
        'subcontractorAdoption.ValidGeneralAuthorityForZakatAndTaxCertificateAttachment',
        subcontractor
            .validGeneralAuthorityForZakatAndTaxCertificateAttachmentPath,
      );
      await putFile(
        'subcontractorAdoption.ValidIndustrialOrCommercialLicenseAttachment',
        subcontractor.validIndustrialOrCommercialLicenseAttachmentPath,
      );
      await putFile(
        'subcontractorAdoption.ValidSaudizationCertificateAttachment',
        subcontractor.validSaudizationCertificateAttachmentPath,
      );
      await putFile(
        'subcontractorAdoption.ValidSocialInsuranceCertificateAttachment',
        subcontractor.validSocialInsuranceCertificateAttachmentPath,
      );
    }

    for (var i = 0; i < executiveBoardAdoptions.length; i++) {
      await putMultipart(
        'executiveBoardAdoptions[$i].Attachment',
        executiveBoardAdoptions[i].attachmentPath,
      );
    }

    final information = informationRequest;
    if (information != null) {
      for (var i = 0; i < information.requestedInformations.length; i++) {
        await putMultipart(
          'informationRequest.RequestedInformations[$i].Attachment',
          information.requestedInformations[i].attachmentPath,
        );
      }
    }

    final materialsAdopt = materialsAdoption;
    if (materialsAdopt != null) {
      Future<void> putFile(String key, String? path) async {
        await putMultipart(key, path);
      }

      await putFile(
        'materialsAdoption.ConformityStatementAttachment',
        materialsAdopt.conformityStatementAttachmentPath,
      );
      await putFile(
        'materialsAdoption.CopyOfSpecificationAttachment',
        materialsAdopt.copyOfSpecificationAttachmentPath,
      );
      await putFile(
        'materialsAdoption.SampleAttachment',
        materialsAdopt.sampleAttachmentPath,
      );
    }

    return FormData.fromMap(map);
  }

  static String _formatRequestDate(DateTime date) {
    return DateFormat('M/d/yyyy, h:mm:ss a', 'en_US').format(date);
  }

  static String _formatDateField(DateTime date) {
    return DateFormat('M/d/yyyy, h:mm:ss a', 'en_US').format(
      DateTime(date.year, date.month, date.day),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

/// Builds a [MultipartFile] for project-request FormData uploads.
/// Works for gallery images and picked documents alike.
Future<MultipartFile> multipartFromLocalPath(String path) async {
  final fileName = _fileNameFromPath(path);
  return MultipartFile.fromFile(
    path,
    filename: fileName,
  );
}

String _fileNameFromPath(String path) {
  final normalized = path.replaceAll('\\', '/');
  final name = normalized.split('/').last;
  return name.isNotEmpty ? name : 'attachment';
}

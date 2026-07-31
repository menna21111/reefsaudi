import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/account_user_type.dart';

part 'profile_model.g.dart';

String _requiredString(dynamic value) => value?.toString() ?? '';

String? _optionalString(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

int? _optionalInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

@JsonSerializable()
class ProfileModel {
  @JsonKey(fromJson: _requiredString)
  final String id;
  @JsonKey(fromJson: _requiredString)
  final String userName;
  @JsonKey(fromJson: _requiredString)
  final String email;
  final int unreadNotifications;
  final List<String> roles;
  final List<String> grantedPermissions;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final int? gender;
  final String? phone;
  final String? designationId;
  final String? departmentId;
  final String? supervisorId;
  @JsonKey(fromJson: _optionalString)
  final String? supervisor;
  final String? designation;
  final String? department;
  final String? profilePicture;
  final String? signaturePath;
  final bool isContractor;
  @JsonKey(fromJson: _optionalInt)
  final int? userType;

  const ProfileModel({
    required this.id,
    required this.userName,
    required this.email,
    this.unreadNotifications = 0,
    this.roles = const [],
    this.grantedPermissions = const [],
    this.firstName,
    this.lastName,
    this.fullName,
    this.gender,
    this.phone,
    this.designationId,
    this.departmentId,
    this.supervisorId,
    this.supervisor,
    this.designation,
    this.department,
    this.profilePicture,
    this.signaturePath,
    this.isContractor = false,
    this.userType,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  String get displayName =>
      (fullName?.trim().isNotEmpty ?? false) ? fullName! : userName;

  bool hasPermission(String permission) =>
      grantedPermissions.contains(permission);

  bool get isContractorAccount =>
      userType == AccountUserType.contractor || isContractor;

  bool get isConsultantAccount => userType == AccountUserType.consultant;

  bool get isAdminAccount {
    if (userType == AccountUserType.admin) return true;
    return roles.any((role) {
      final normalized = role.toLowerCase().trim();
      return normalized.contains('admin') ||
          role.contains('مدير') ||
          role.contains('مسؤول النظام');
    });
  }

  bool get isNormalUserAccount => userType == AccountUserType.normalUser;
}

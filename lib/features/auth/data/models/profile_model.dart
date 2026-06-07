import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String id;
  final String userName;
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
  final String? designation;
  final String? department;
  final String? profilePicture;
  final String? signaturePath;
  final bool isContractor;

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
    this.designation,
    this.department,
    this.profilePicture,
    this.signaturePath,
    this.isContractor = false,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  String get displayName =>
      (fullName?.trim().isNotEmpty ?? false) ? fullName! : userName;

  bool hasPermission(String permission) =>
      grantedPermissions.contains(permission);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: _requiredString(json['id']),
  userName: _requiredString(json['userName']),
  email: _requiredString(json['email']),
  unreadNotifications: (json['unreadNotifications'] as num?)?.toInt() ?? 0,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  grantedPermissions:
      (json['grantedPermissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  fullName: json['fullName'] as String?,
  gender: (json['gender'] as num?)?.toInt(),
  phone: json['phone'] as String?,
  designationId: json['designationId'] as String?,
  departmentId: json['departmentId'] as String?,
  supervisorId: json['supervisorId'] as String?,
  supervisor: _optionalString(json['supervisor']),
  designation: json['designation'] as String?,
  department: json['department'] as String?,
  profilePicture: json['profilePicture'] as String?,
  signaturePath: json['signaturePath'] as String?,
  isContractor: json['isContractor'] as bool? ?? false,
  userType: _optionalInt(json['userType']),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'unreadNotifications': instance.unreadNotifications,
      'roles': instance.roles,
      'grantedPermissions': instance.grantedPermissions,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'gender': instance.gender,
      'phone': instance.phone,
      'designationId': instance.designationId,
      'departmentId': instance.departmentId,
      'supervisorId': instance.supervisorId,
      'supervisor': instance.supervisor,
      'designation': instance.designation,
      'department': instance.department,
      'profilePicture': instance.profilePicture,
      'signaturePath': instance.signaturePath,
      'isContractor': instance.isContractor,
      'userType': instance.userType,
    };

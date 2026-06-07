// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: json['id'] as String,
  userName: json['userName'] as String,
  email: json['email'] as String,
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
  designation: json['designation'] as String?,
  department: json['department'] as String?,
  profilePicture: json['profilePicture'] as String?,
  signaturePath: json['signaturePath'] as String?,
  isContractor: json['isContractor'] as bool? ?? false,
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
      'designation': instance.designation,
      'department': instance.department,
      'profilePicture': instance.profilePicture,
      'signaturePath': instance.signaturePath,
      'isContractor': instance.isContractor,
    };

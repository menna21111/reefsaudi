import 'package:equatable/equatable.dart';

class RoleItem extends Equatable {
  const RoleItem({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class RoleListResult extends Equatable {
  const RoleListResult({
    required this.items,
    required this.totalCount,
  });

  final List<RoleItem> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class RolePermission extends Equatable {
  const RolePermission({
    required this.name,
    required this.displayName,
    required this.value,
  });

  final String name;
  final String displayName;
  final bool value;

  RolePermission copyWith({bool? value}) {
    return RolePermission(
      name: name,
      displayName: displayName,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [name, displayName, value];
}

class RolePermissionGroup extends Equatable {
  const RolePermissionGroup({
    required this.groupName,
    required this.permissions,
  });

  final String groupName;
  final List<RolePermission> permissions;

  RolePermissionGroup copyWith({List<RolePermission>? permissions}) {
    return RolePermissionGroup(
      groupName: groupName,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  List<Object?> get props => [groupName, permissions];
}

class RoleDetails extends Equatable {
  const RoleDetails({
    required this.id,
    required this.name,
    required this.permissionGroups,
  });

  final String id;
  final String name;
  final List<RolePermissionGroup> permissionGroups;

  List<String> get selectedPermissionNames => permissionGroups
      .expand((group) => group.permissions)
      .where((permission) => permission.value)
      .map((permission) => permission.name)
      .toList();

  RoleDetails copyWith({
    String? name,
    List<RolePermissionGroup>? permissionGroups,
  }) {
    return RoleDetails(
      id: id,
      name: name ?? this.name,
      permissionGroups: permissionGroups ?? this.permissionGroups,
    );
  }

  @override
  List<Object?> get props => [id, name, permissionGroups];
}

class RoleWriteRequest extends Equatable {
  const RoleWriteRequest({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class RoleUpdateRequest extends Equatable {
  const RoleUpdateRequest({
    required this.id,
    required this.name,
    required this.selectedPermissions,
  });

  final String id;
  final String name;
  final List<String> selectedPermissions;

  @override
  List<Object?> get props => [id, name, selectedPermissions];
}

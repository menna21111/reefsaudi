import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/models/profile_model.dart';
import 'permission_cubit.dart';

/// يظهر [child] فقط لو المستخدم عنده [permission].
class PermissionGate extends StatelessWidget {
  const PermissionGate({
    super.key,
    required this.permission,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    this.requireEdit = false,
    this.editPermission,
    this.allowAdmin = false,
  });

  final String permission;
  final String? editPermission;
  final bool requireEdit;
  final bool allowAdmin;
  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, ProfileModel?>(
      builder: (context, _) {
        final cubit = context.read<PermissionCubit>();
        final canView =
            (allowAdmin && cubit.isAdmin) || cubit.has(permission);
        if (!canView) return fallback;

        if (requireEdit && editPermission != null) {
          if (!(allowAdmin && cubit.isAdmin) &&
              !cubit.has(editPermission!)) {
            return fallback;
          }
        }

        return child;
      },
    );
  }
}

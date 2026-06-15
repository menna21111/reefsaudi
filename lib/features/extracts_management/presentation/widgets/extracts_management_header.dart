import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/applogo.dart';

class ExtractsManagementHeader extends StatelessWidget {
  const ExtractsManagementHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Applogo(height: 40.h, width: 40.w),
    );
  }
}

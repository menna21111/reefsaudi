import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/entities/financial_requirement.dart';
import '../cubit/financial_statement_form_cubit.dart';
import '../widgets/financial_requirement_form_view.dart';

class FinancialRequirementEditScreen extends StatelessWidget {
  const FinancialRequirementEditScreen({super.key, required this.item});

  final FinancialRequirement item;

  static Future<bool?> open(
    BuildContext context, {
    required FinancialRequirement item,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FinancialRequirementEditScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocProvider(
      create: (_) => sl<FinancialStatementFormCubit>(),
      child: Scaffold(
        backgroundColor: colors.kBgColor,
        appBar: AppBar(
          backgroundColor: colors.kInputColor,
          foregroundColor: colors.kFontColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: colors.kPrimaryColor, size: 22.sp),
          title: Text(
            'edit_financial_statement'.tr(),
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Almarai',
            ),
          ),
        ),
        body: FinancialRequirementFormView(item: item, isEditing: true),
      ),
    );
  }
}

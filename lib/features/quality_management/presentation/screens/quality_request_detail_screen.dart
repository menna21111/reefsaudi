import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/utils/enums.dart';
import '../cubit/quality_management_cubit.dart';
import '../widgets/quality_request_detail/quality_request_detail_body.dart';

class QualityRequestDetailScreen extends StatelessWidget {
  const QualityRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  final String requestId;

  static Route<void> route(String requestId) {
    return MaterialPageRoute<void>(
      builder: (_) => QualityRequestDetailScreen(requestId: requestId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QualityManagementCubit>()..loadDetail(requestId),
      child: _QualityRequestDetailView(requestId: requestId),
    );
  }
}

class _QualityRequestDetailView extends StatelessWidget {
  const _QualityRequestDetailView({required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.kFontColor),
        title: Text(
          AppString.requestDetails.tr(),
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
          if (state.detailStatus == RequestStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state.detailStatus == RequestStatus.error) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.detailError.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.kFontColor,
                        fontSize: 14.sp,
                        fontFamily: 'Almarai',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () => context
                          .read<QualityManagementCubit>()
                          .loadDetail(requestId),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.detailStatus != RequestStatus.success ||
              state.detail == null) {
            return const SizedBox.shrink();
          }

          return QualityRequestDetailBody(
            requestId: requestId,
            detail: state.detail!,
          );
        },
      ),
    );
  }
}

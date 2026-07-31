import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/widgets/riyal_price.dart';
import '../../../data/models/portfolio_overview_models.dart';
import 'portfolio_financial_sub_stat.dart';
import 'portfolio_money_utils.dart';

class PortfolioFinancialCard extends StatelessWidget {
  const PortfolioFinancialCard({
    super.key,
    required this.financial,
  });

  final FinancialStatementProjectsDto financial;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final total = financial.progressTotal > 0 ? financial.progressTotal : 1.0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          
          top: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.25)),
        
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: colors.kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: colors.kPrimaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.totalClaims.tr(),
                      style: TextStyle(
                        color: colors.kGrayColor,
                        fontSize: 11.sp,
                      ),
                    ),
                    RiyalPriceLabel(
                      price: PortfolioMoneyUtils.formatCompact(
                        financial.reclaimedTotalSum,
                      ),
                      iconSize: 18.sp,
                      
                      style: TextStyle(
                        color: colors.kWhiteColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Row(
              children: [
                if (financial.remainingAmount > 0)
                  Expanded(
                    flex: (financial.remainingAmount / total * 100)
                        .round()
                        .clamp(1, 100),
                    child: Container(
                      height: 10.h,
                      color: colors.kGrayColor.withValues(alpha: 0.4),
                    ),
                  ),
                if (financial.underStudiesAmount > 0)
                  Expanded(
                    flex: (financial.underStudiesAmount / total * 100)
                        .round()
                        .clamp(1, 100),
                    child: Container(
                      height: 10.h,
                      color: colors.kGoldColor,
                    ),
                  ),
                if (financial.paidAmount > 0)
                  Expanded(
                    flex: (financial.paidAmount / total * 100)
                        .round()
                        .clamp(1, 100),
                    child: Container(
                      height: 10.h,
                      color: colors.kPrimaryColor,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: PortfolioFinancialSubStat(
                  label: AppString.disbursed.tr(),
                  value: PortfolioMoneyUtils.formatCompact(financial.paidAmount),
                  color: colors.kPrimaryColor,
                ),
              ),
              Expanded(
                child: PortfolioFinancialSubStat(
                  label: AppString.underProcess.tr(),
                  value: PortfolioMoneyUtils.formatCompact(
                    financial.underStudiesAmount,
                  ),
                  color: colors.kGoldColor,
                ),
              ),
              Expanded(
                child: PortfolioFinancialSubStat(
                  label: AppString.remaining.tr(),
                  value: PortfolioMoneyUtils.formatCompact(
                    financial.remainingAmount,
                  ),
                  color: colors.kGrayColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: colors.kBorderColor.withValues(alpha: 0.2)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.totalClaimsCount.tr(),
                style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
              ),
              Text(
                '${financial.reclaimedTotalCount} ${AppString.claimsUnit.tr()}',
                style: TextStyle(
                  color: colors.kWhiteColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

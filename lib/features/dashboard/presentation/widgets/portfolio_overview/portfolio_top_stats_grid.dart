import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../data/models/portfolio_overview_models.dart';
import 'portfolio_money_utils.dart';
import 'portfolio_overview_stat_card.dart';

class PortfolioTopStatsGrid extends StatelessWidget {
  const PortfolioTopStatsGrid({
    super.key,
    required this.sectors,
  });

  final ProjectsFinancialSectorsDto sectors;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final gap = 12.w;
    final cards = [
      PortfolioOverviewStatCard(
        title: AppString.totalBudget.tr(),
        mainValue: PortfolioMoneyUtils.formatCompact(sectors.totalBudget),
        subValue: PortfolioMoneyUtils.formatFull(sectors.totalBudget),
        valueColor: colors.kPrimaryColor,
        topBorderColor: colors.kPrimaryColor,
        withRiyal: true,
      ),
      PortfolioOverviewStatCard(
        title: AppString.existingProjectsBudget.tr(),
        subValue:
            PortfolioMoneyUtils.formatFull(sectors.totalProjectsActualBudget),
        mainValue: PortfolioMoneyUtils.formatCompact(
          sectors.totalProjectsActualBudget,
        ),
        valueColor: colors.kWhiteColor,
        topBorderColor: const Color(0xFF60A5FA),
        withRiyal: true,
      ),
      PortfolioOverviewStatCard(
        title: AppString.projects.tr(),
        mainValue: '${sectors.projectsCount}',
        icon: Icons.folder_open_outlined,
        valueColor: colors.kWhiteColor,
        topBorderColor: colors.kGoldColor,
      ),
      PortfolioOverviewStatCard(
        title: AppString.sectors.tr(),
        mainValue: '${sectors.sectorsCount}',
        icon: Icons.category_outlined,
        valueColor: colors.kWhiteColor,
        topBorderColor: const Color(0xFF34D399),
      ),
    ];

    if (context.isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Expanded(child: cards[i]),
          ],
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cards[0]),
            SizedBox(width: gap),
            Expanded(child: cards[1]),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: cards[2]),
            SizedBox(width: gap),
            Expanded(child: cards[3]),
          ],
        ),
      ],
    );
  }
}

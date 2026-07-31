import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../data/models/portfolio_overview_models.dart';
import 'portfolio_money_utils.dart';
import 'portfolio_status_card.dart';

class PortfolioProjectStatusGrid extends StatelessWidget {
  const PortfolioProjectStatusGrid({
    super.key,
    required this.status,
  });

  final ProjectStatusCountsDto status;

  @override
  Widget build(BuildContext context) {
    final gap = 12.w;
    final cards = [
      PortfolioStatusCard(
        title: AppString.underTendering.tr(),
        count: status.tenderCount,
        amount: PortfolioMoneyUtils.formatCompact(status.tenderSum),
        icon: Icons.description_outlined,
        iconColor: const Color(0xFF60A5FA),
      ),
      PortfolioStatusCard(
        title: AppString.projectTypeAwarded.tr(),
        count: status.awardedCount,
        amount: PortfolioMoneyUtils.formatCompact(status.awardedSum),
        icon: Icons.check_circle_outline,
        iconColor: const Color(0xFF34D399),
      ),
      PortfolioStatusCard(
        title: AppString.inProgress.tr(),
        count: status.startedCount,
        amount: PortfolioMoneyUtils.formatCompact(status.startedSum),
        icon: Icons.sync,
        iconColor: const Color(0xFFFBBF24),
      ),
      PortfolioStatusCard(
        title: AppString.completedProjects.tr(),
        count: status.finishedCount,
        amount: PortfolioMoneyUtils.formatCompact(status.finishedSum),
        icon: Icons.done_all,
        iconColor: const Color(0xFF94A3B8),
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

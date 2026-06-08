import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'big_total_card.dart';
import 'claims_card.dart';
import 'count_card.dart';
import 'top_sector_card.dart';

class FinancialSummaryCards extends StatelessWidget {
  const FinancialSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BigTotalCard(),
        SizedBox(height: 12.h),
        Row(
          children: [
            const Expanded(child: ClaimsCard()),
            SizedBox(width: 12.w),
            const Expanded(child: CountCard()),
          ],
        ),
        SizedBox(height: 12.h),
        const TopSectorCard(),
      ],
    );
  }
}

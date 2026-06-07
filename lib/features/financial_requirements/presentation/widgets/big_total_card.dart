import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color.dart';

import '../../../../core/utils/app_string.dart';

import 'card_section.dart';



class BigTotalCard extends StatelessWidget {

  const BigTotalCard({super.key});



  String _amountWithCurrency(String amount) {

    return AppString.amountWithCurrency.tr(namedArgs: {

      'amount': amount,

      'currency': AppString.currencyRiyal.tr(),

    });

  }



  @override

  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),

      decoration: BoxDecoration(

        color: AppColor.kSurfaceColor,

        borderRadius: BorderRadius.circular(16.r),

        border: BorderDirectional(

          start: BorderSide(color: AppColor.kSecondaryColor, width: 4.w),

        ),

      ),

      child: Column(

        children: [

          CardSection(

            title: AppString.extractsCount.tr(),

            mainValue: '281',

            subtitle: AppString.extractsCountSubtitle.tr(namedArgs: {

              'paid': '239',

              'inProcess': '42',

            }),

          ),

          Padding(

            padding: EdgeInsets.symmetric(vertical: 10.h),

            child: Divider(

              color: AppColor.kBorderColor.withOpacity(0.6),

              thickness: 1.5,

              height: 1,

            ),

          ),

          CardSection(

            title: AppString.totalExtractsValue.tr(),

            mainValue: _amountWithCurrency('323.1M'),

            subtitle: AppString.extractsValueSubtitle.tr(namedArgs: {

              'paidAmount': '273.0M',

              'inProcessAmount': '50.1M',

            }),

          ),

          Padding(

            padding: EdgeInsets.symmetric(vertical: 10.h),

            child: Divider(

              color: AppColor.kBorderColor.withOpacity(0.6),

              thickness: 1.5,

              height: 1,

            ),

          ),

          CardSection(

            title: AppString.currentReefClaims.tr(),

            mainValue: _amountWithCurrency('0'),

            subtitle: AppString.previousMonthValue.tr(namedArgs: {

              'amount': _amountWithCurrency('0'),

            }),

            percentage: '0.0%',

          ),

        ],

      ),

    );

  }

}



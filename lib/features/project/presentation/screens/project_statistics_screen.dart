import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';

// Import all widgets
import '../widgets/cash_flow_widget.dart';
import '../widgets/execution_rate_chart_widget.dart';
import '../widgets/executive_summary_widget.dart';
import '../widgets/financial_data_widget.dart';
import '../widgets/map_intrecative.dart';
import '../widgets/next_payment_widget.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/project_details_widget.dart';
import '../widgets/project_header_widget.dart';
import '../widgets/project_stages_widget.dart';
import '../widgets/risk_matrix_widget.dart';

class ProjectStatisticsScreen extends StatefulWidget {
  const ProjectStatisticsScreen({super.key});

  @override
  State<ProjectStatisticsScreen> createState() =>
      _ProjectStatisticsScreenState();
}

class _ProjectStatisticsScreenState extends State<ProjectStatisticsScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    // Create 10 animation controllers for different sections
    _controllers = List.generate(
      10,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.kPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColor.kPrimaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildAnimatedSection(
              0,
              const ProjectHeaderWidget(
                category: 'المشروع الثانوية - مشروع فرعي',
                title: 'أعمال إنشائية في محطة ملاكات\nالطبل بالرياض',
                status: 'جاري',
                daysRunning: 735,
              ),
            ),

            SizedBox(height: 24.h),
            // SaudiMapCard(),
            // Progress Indicator Section (Pie Chart)
            _buildAnimatedSection(
              1,
              const ProgressIndicatorWidget(progress: 0.87),
            ),

            SizedBox(height: 24.h),

            // Executive Summary
            _buildAnimatedSection(
              2,
              ExecutiveSummaryWidget(
                summary:
                    'تمثل المشاريع قصيرة المدى أعمال البنية التحتية بمنية سدير، أعمال البنية التحتية والموقع العام التنمية العمرانية بوادي البقع إضافة لإنشاءات الحقول والمباني والطرق.',
                onMorePressed: () {},
              ),
            ),

            SizedBox(height: 24.h),

            // Project Stages
            _buildAnimatedSection(
              3,
              ProjectStagesWidget(
                stages: [
                  StageData(label: 'التخطيط', progress: 0.8),
                  StageData(label: 'التنفيذ', progress: 0.9),
                  StageData(label: 'المراقبة', progress: 0.7),
                  StageData(label: 'الإغلاق', progress: 0.95),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Project Details
            _buildAnimatedSection(
              4,
              const ProjectDetailsWidget(
                status: 'مستمر',
                statusColor: 'primary',
                completionRate: '87%',
                responsibleParty: 'مكتب إدارة المشاريع',
                startDate: '2022-06-10',
                endDate: '2024-06-10',
              ),
            ),

            SizedBox(height: 24.h),

            // Financial Data
            _buildAnimatedSection(
              5,
              const FinancialDataWidget(
                totalBudget: 8.0,
                actualExpenses: 5.2,
                remaining: 2.8,
                budgetStatus: 'متأخر',
                budgetStatusColor: 'red',
              ),
            ),

            SizedBox(height: 24.h),

            // Risk Matrix
            _buildAnimatedSection(
              6,
              const RiskMatrixWidget(markerIndex: 17, advancedRisksCount: 3),
            ),

            SizedBox(height: 24.h),

            // Execution Rate Chart
            _buildAnimatedSection(
              7,
              const ExecutionRateChartWidget(
                dataPoints: [0, 15, 30, 40, 55, 65, 75, 87],
              ),
            ),

            SizedBox(height: 24.h),

            // Cash Flow
            _buildAnimatedSection(
              8,
              const CashFlowWidget(
                line1Data: [20, 40, 35, 55, 50, 70, 65, 80],
                line2Data: [10, 25, 30, 40, 45, 55, 60, 70],
                line3Data: [5, 15, 20, 30, 35, 45, 50, 60],
              ),
            ),

            SizedBox(height: 24.h),

            // Next Payment
            _buildAnimatedSection(
              9,
              const NextPaymentWidget(amount: 120000, date: '2024-07-15'),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(int index, Widget child) {
    return FadeTransition(
      opacity: _animations[index],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_animations[index]),
        child: child,
      ),
    );
  }
}

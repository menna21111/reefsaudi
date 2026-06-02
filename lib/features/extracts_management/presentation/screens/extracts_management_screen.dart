import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../domain/models/extract_item.dart';
import '../widgets/extracts_management_header.dart';
import '../widgets/extracts_page_title_row.dart';
import '../widgets/extracts_search_action_row.dart';
import '../widgets/extracts_summary_cards.dart';
import '../widgets/extracts_table.dart';
import '../widgets/extracts_table.dart';

class ExtractsManagementScreen extends StatefulWidget {
  const ExtractsManagementScreen({super.key});

  @override
  State<ExtractsManagementScreen> createState() =>
      _ExtractsManagementScreenState();
}

class _ExtractsManagementScreenState extends State<ExtractsManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ExtractItem> get _filteredItems {
    if (_searchQuery.isEmpty) return mockExtractItems;

    final query = _searchQuery.trim();
    return mockExtractItems
        .where(
          (item) =>
              item.sector.contains(query) ||
              item.extractNumber.contains(query) ||
              item.managementStatus.contains(query) ||
              item.status.label.contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              sliver: const SliverToBoxAdapter(
                child: ExtractsManagementHeader(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: const SliverToBoxAdapter(
                child: ExtractsPageTitleRow(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: const SliverToBoxAdapter(
                child: ExtractsSummaryCards(),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                child: ExtractsSearchActionRow(
                  searchController: _searchController,
                  onSearchChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                child: ExtractsTable(items: filtered),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          ],
        ),
      ),
    );
  }
}

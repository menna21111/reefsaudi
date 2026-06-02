import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../domain/models/extract_item.dart';
import 'extracts_table_empty_state.dart';
import 'extracts_table_header.dart';
import 'extracts_table_row.dart';

class ExtractsTable extends StatelessWidget {
  final List<ExtractItem> items;

  const ExtractsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const ExtractsTableEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          const ExtractsTableHeader(),
          ...items.asMap().entries.map(
                (entry) => ExtractsTableRow(
                  item: entry.value,
                  isEven: entry.key.isEven,
                ),
              ),
        ],
      ),
    );
  }
}

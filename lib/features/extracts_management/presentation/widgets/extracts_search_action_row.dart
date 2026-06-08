import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'extracts_add_button.dart';
import 'extracts_search_field.dart';

class ExtractsSearchActionRow extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback? onSearchSubmitted;
  final VoidCallback? onAddTap;

  const ExtractsSearchActionRow({
    super.key,
    required this.searchController,
    this.onSearchSubmitted,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ExtractsSearchField(
            controller: searchController,
            onSubmitted: (_) => onSearchSubmitted?.call(),
          ),
        ),
        SizedBox(width: 12.w),
        ExtractsAddButton(onTap: onAddTap),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'extracts_add_button.dart';
import 'extracts_search_field.dart';

class ExtractsSearchActionRow extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAddTap;

  const ExtractsSearchActionRow({
    super.key,
    required this.searchController,
    this.onSearchChanged,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ExtractsSearchField(
            controller: searchController,
            onChanged: onSearchChanged,
          ),
        ),
        SizedBox(width: 12.w),
        ExtractsAddButton(onTap: onAddTap),
      ],
    );
  }
}

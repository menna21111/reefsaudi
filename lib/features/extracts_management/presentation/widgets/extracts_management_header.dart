import 'package:flutter/material.dart';
import 'extracts_brand_row.dart';
import 'extracts_profile_avatar.dart';

class ExtractsManagementHeader extends StatelessWidget {
  const ExtractsManagementHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExtractsBrandRow(),
        ExtractsProfileAvatar(),
      ],
    );
  }
}

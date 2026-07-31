import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/widgets/styled_popup_dropdown.dart';
import '../../../data/models/portfolio_overview_models.dart';

class PortfolioSectorDropdown extends StatelessWidget {
  const PortfolioSectorDropdown({
    super.key,
    required this.brands,
    required this.selectedBrandId,
    required this.onChanged,
  });

  static const String allSectorsValue = '__all_sectors__';

  final List<BrandDto> brands;
  final String? selectedBrandId;
  final ValueChanged<BrandDto?> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<String>>[
      DropdownMenuItem(
        value: allSectorsValue,
        child: Text(AppString.allSectors.tr()),
      ),
      ...brands.map(
        (brand) => DropdownMenuItem(
          value: brand.id,
          child: Text(brand.title),
        ),
      ),
    ];

    return StyledPopupDropdown<String>(
      title: AppString.sector.tr(),
      hintText: AppString.allSectors.tr(),
      prefixIcon: const Icon(Icons.category_outlined),
      value: selectedBrandId ?? allSectorsValue,
      items: items,
      onChanged: (value) {
        if (value == null || value == allSectorsValue) {
          onChanged(null);
          return;
        }

        final brand = brands.firstWhere((b) => b.id == value);
        onChanged(brand);
      },
    );
  }
}

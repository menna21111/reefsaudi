class RiskEnumOption {
  final int value;
  final String labelKey;

  const RiskEnumOption({required this.value, required this.labelKey});
}

class RiskEnums {
  static const riskStatus = [
    RiskEnumOption(value: 0, labelKey: 'risk_status_new'),
    RiskEnumOption(value: 1, labelKey: 'risk_status_open'),
    RiskEnumOption(value: 2, labelKey: 'risk_status_closed'),
  ];

  static const riskProbability = [
    RiskEnumOption(value: 0, labelKey: 'risk_level_very_low'),
    RiskEnumOption(value: 1, labelKey: 'risk_level_low'),
    RiskEnumOption(value: 2, labelKey: 'risk_level_medium'),
    RiskEnumOption(value: 3, labelKey: 'risk_level_high'),
    RiskEnumOption(value: 4, labelKey: 'risk_level_very_high'),
  ];

  static const riskImpact = [
    RiskEnumOption(value: 0, labelKey: 'risk_level_very_low'),
    RiskEnumOption(value: 1, labelKey: 'risk_level_low'),
    RiskEnumOption(value: 2, labelKey: 'risk_level_medium'),
    RiskEnumOption(value: 3, labelKey: 'risk_level_high'),
    RiskEnumOption(value: 4, labelKey: 'risk_level_very_high'),
  ];

  static const riskPriority = [
    RiskEnumOption(value: 0, labelKey: 'risk_priority_low'),
    RiskEnumOption(value: 1, labelKey: 'risk_priority_medium'),
    RiskEnumOption(value: 2, labelKey: 'risk_priority_high'),
    RiskEnumOption(value: 3, labelKey: 'risk_priority_critical'),
  ];

  static const riskResponse = [
    RiskEnumOption(value: 0, labelKey: 'risk_response_avoid'),
    RiskEnumOption(value: 1, labelKey: 'risk_response_mitigate'),
    RiskEnumOption(value: 2, labelKey: 'risk_response_transfer'),
    RiskEnumOption(value: 3, labelKey: 'risk_response_accept'),
  ];

  static String labelForValue(List<RiskEnumOption> options, int value) {
    return options
        .firstWhere(
          (option) => option.value == value,
          orElse: () => RiskEnumOption(value: value, labelKey: '$value'),
        )
        .labelKey;
  }
}

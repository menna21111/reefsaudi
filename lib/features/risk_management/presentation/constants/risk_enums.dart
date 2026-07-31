class RiskStringOption {
  const RiskStringOption({required this.value, required this.labelKey});

  final String value;
  final String labelKey;
}

abstract final class RiskApiEnums {
  static const riskImpact = [
    RiskStringOption(value: 'Certain', labelKey: 'risk_impact_certain'),
    RiskStringOption(value: 'likely', labelKey: 'risk_impact_likely'),
    RiskStringOption(value: 'moderate', labelKey: 'risk_impact_moderate'),
    RiskStringOption(value: 'Unlikely', labelKey: 'risk_impact_unlikely'),
    RiskStringOption(value: 'rare', labelKey: 'risk_impact_rare'),
  ];

  static const riskPriority = [
    RiskStringOption(value: 'VeryHigh', labelKey: 'risk_priority_very_high'),
    RiskStringOption(value: 'High', labelKey: 'risk_priority_high'),
    RiskStringOption(value: 'Medium', labelKey: 'risk_priority_medium'),
    RiskStringOption(value: 'Closed', labelKey: 'risk_status_closed'),
  ];

  static const riskProbability = [
    RiskStringOption(
      value: 'VerylikelyToOccur',
      labelKey: 'risk_probability_very_likely',
    ),
    RiskStringOption(
      value: 'likelyToOccur',
      labelKey: 'risk_probability_likely',
    ),
    RiskStringOption(value: 'MayOccur', labelKey: 'risk_probability_may'),
    RiskStringOption(
      value: 'unlikelyToOccur',
      labelKey: 'risk_probability_unlikely',
    ),
    RiskStringOption(
      value: 'VerylowToOccur',
      labelKey: 'risk_probability_very_low',
    ),
  ];

  static const riskResponse = [
    RiskStringOption(value: 'Avoid', labelKey: 'risk_response_avoid'),
    RiskStringOption(value: 'Mitigate', labelKey: 'risk_response_mitigate'),
    RiskStringOption(value: 'Transfer', labelKey: 'risk_response_transfer'),
    RiskStringOption(value: 'Accept', labelKey: 'risk_response_accept'),
  ];

  static const riskStatus = [
    RiskStringOption(value: 'Open', labelKey: 'risk_status_open'),
    RiskStringOption(value: 'Closed', labelKey: 'risk_status_closed'),
    RiskStringOption(value: 'Pending', labelKey: 'risk_status_pending'),
    RiskStringOption(value: 'Realized', labelKey: 'risk_status_realized'),
  ];

  static String labelKeyFor(
    List<RiskStringOption> options,
    String? value,
  ) {
    if (value == null || value.isEmpty) return '';
    return options
        .where((o) => o.value.toLowerCase() == value.toLowerCase())
        .map((o) => o.labelKey)
        .firstOrNull ?? value;
  }
}

/// Maps UI string options to API numeric codes (index-based, same as web).
abstract final class RiskApiValueMapper {
  static int _indexOf(List<RiskStringOption> options, String value) {
    final normalized = value.trim().toLowerCase();
    final index = options.indexWhere(
      (o) => o.value.toLowerCase() == normalized,
    );
    return index >= 0 ? index : 0;
  }

  static String _fromApi(List<RiskStringOption> options, dynamic raw) {
    if (raw is int) {
      if (raw >= 0 && raw < options.length) return options[raw].value;
      return raw.toString();
    }
    final text = raw?.toString().trim() ?? '';
    if (text.isEmpty) return '';
    final parsed = int.tryParse(text);
    if (parsed != null && parsed >= 0 && parsed < options.length) {
      return options[parsed].value;
    }
    final index = options.indexWhere(
      (o) => o.value.toLowerCase() == text.toLowerCase(),
    );
    return index >= 0 ? options[index].value : text;
  }

  static int impactToApi(String value) =>
      _indexOf(RiskApiEnums.riskImpact, value);

  static String priorityToApi(String value) =>
      _indexOf(RiskApiEnums.riskPriority, value).toString();

  static int probabilityToApi(String value) =>
      _indexOf(RiskApiEnums.riskProbability, value);

  static int responseToApi(String value) =>
      _indexOf(RiskApiEnums.riskResponse, value);

  static int statusToApi(String value) =>
      _indexOf(RiskApiEnums.riskStatus, value);

  static String impactFromApi(dynamic raw) =>
      _fromApi(RiskApiEnums.riskImpact, raw);

  static String priorityFromApi(dynamic raw) =>
      _fromApi(RiskApiEnums.riskPriority, raw);

  static String probabilityFromApi(dynamic raw) =>
      _fromApi(RiskApiEnums.riskProbability, raw);

  static String responseFromApi(dynamic raw) =>
      _fromApi(RiskApiEnums.riskResponse, raw);

  static String statusFromApi(dynamic raw) =>
      _fromApi(RiskApiEnums.riskStatus, raw);
}

/// Backward-compatible alias used across risk management widgets.
typedef RiskEnumOption = RiskStringOption;

abstract final class RiskEnums {
  static const riskImpact = RiskApiEnums.riskImpact;
  static const riskPriority = RiskApiEnums.riskPriority;
  static const riskProbability = RiskApiEnums.riskProbability;
  static const riskResponse = RiskApiEnums.riskResponse;
  static const riskStatus = RiskApiEnums.riskStatus;

  static String labelForValue(
    List<RiskStringOption> options,
    dynamic value,
  ) =>
      RiskApiEnums.labelKeyFor(
        options,
        value?.toString(),
      );
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

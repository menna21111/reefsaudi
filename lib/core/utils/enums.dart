enum RequestStatus { initial, loading, success, error, empty, loaded, navigate, unauthenticated }


enum Diagnosis {
  BECK_ANXIETY_INVENTORY_BAI,
  BECK_S_DEPRESSION_INVENTORY,
  GAD_7_ANXIETY,
  K10_DISTRESS,
  PHQ_9_DEPRESSION,
  PSS_STRESS,
  WEMWBS
}

final diagnosisValues = EnumValues({
  "Beck Anxiety Inventory (BAI)": Diagnosis.BECK_ANXIETY_INVENTORY_BAI,
  "Beck's Depression Inventory": Diagnosis.BECK_S_DEPRESSION_INVENTORY,
  "GAD-7 Anxiety": Diagnosis.GAD_7_ANXIETY,
  "K10 Distress": Diagnosis.K10_DISTRESS,
  "PHQ-9 Depression": Diagnosis.PHQ_9_DEPRESSION,
  "PSS Stress": Diagnosis.PSS_STRESS,
  "wemwbs": Diagnosis.WEMWBS
});


class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

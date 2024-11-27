class Result {
  Map<String, String> values;

  Result({required this.values});

  Result.fromJson(Map<String, dynamic> json)
      : values = json.map((key, value) => MapEntry(key, value.toString()));

  Map<String, dynamic> toJson() {
    return values;
  }
}
class Country {
  final String common;
  Country({required this.common});

  factory Country.fromJson(Map<String,dynamic> json) {
    return Country(common: json['name']['common']);
  }

}
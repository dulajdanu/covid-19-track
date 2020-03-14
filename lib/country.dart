class Country {
  String code;
  String name;

  Country(this.code, this.name);

  Country.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Name'] = this.name;
    return data;
  }
}

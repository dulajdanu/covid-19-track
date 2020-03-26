import 'package:hive/hive.dart';
part 'countryModel.g.dart';

@HiveType(typeId: 1)
class CountryModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String code;

  CountryModel(this.name, this.code);
}

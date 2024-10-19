import 'package:formulator/src/entities/models/section.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'formula.g.dart';

@HiveType(typeId: 0)
class Formula {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<Section> sections;

  const Formula({required this.name, required this.sections});

  @override
  String toString() {
    return 'Formula{name: $name, sections: $sections}';
  }
}

import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'section.g.dart';

@HiveType(typeId: 1)
class Section {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double weight;

  @HiveField(2)
  final List<SubSection> subsections;

  const Section({
    required this.name,
    required this.weight,
    required this.subsections,
  });

  @override
  String toString() {
    return 'Section{name: $name, weight: $weight, subsections: $subsections}';
  }
}

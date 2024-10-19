import 'package:formulator/src/entities/models/entry.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'sub_section.g.dart';

@HiveType(typeId: 2)
class SubSection {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double weight;

  @HiveField(2)
  final List<Entry> entries;

  const SubSection({
    required this.name,
    required this.weight,
    required this.entries,
  });

  @override
  String toString() {
    return 'SubSection{name: $name, weight: $weight, entries: $entries}';
  }
}

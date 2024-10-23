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

  double get totalEntriesWeight =>
      entries.fold(0, (prev, element) => prev + element.weight);

  double get answer {
    if (entries.isNotEmpty) {
      return entries.fold<double>(
        0.0,
        (prev, element) =>
            prev + ((element.weight / totalEntriesWeight) * element.answer),
      );
    } else {
      return 0;
    }
  }

  const SubSection({
    required this.name,
    required this.weight,
    required this.entries,
  });

  SubSection copyWith({
    String? name,
    double? weight,
    List<Entry>? entries,
  }) {
    return SubSection(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      entries: entries ?? this.entries,
    );
  }

  @override
  String toString() {
    return 'SubSection{name: $name, weight: $weight, entries: $entries}';
  }
}

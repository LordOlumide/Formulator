import 'package:hive_flutter/hive_flutter.dart';

part 'entry.g.dart';

@HiveType(typeId: 3)
class Entry {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double value;

  @HiveField(2)
  final double referenceValue;

  @HiveField(3)
  final double weight;

  const Entry({
    required this.name,
    required this.value,
    required this.referenceValue,
    required this.weight,
  });

  @override
  String toString() {
    return 'Entry{name: $name, value: $value, referenceValue: $referenceValue, '
        'weight: $weight}';
  }
}

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

  @HiveField(4)
  final double costPerUnit;

  double get answer => value / referenceValue;

  const Entry({
    required this.name,
    required this.value,
    required this.referenceValue,
    required this.weight,
    required this.costPerUnit,
  });

  Entry copyWith({
    String? name,
    double? value,
    double? referenceValue,
    double? weight,
    double? costPerUnit,
  }) {
    return Entry(
      name: name ?? this.name,
      value: value ?? this.value,
      referenceValue: referenceValue ?? this.referenceValue,
      weight: weight ?? this.weight,
      costPerUnit: costPerUnit ?? this.costPerUnit,
    );
  }

  @override
  String toString() {
    return 'Entry{name: $name, value: $value, referenceValue: $referenceValue, '
        'weight: $weight, costPerUnit: $costPerUnit}';
  }
}

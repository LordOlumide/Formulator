import 'package:formulator/src/entities/models/entry.dart';

class EntryWithAmount extends Entry {
  final double? amountAdded;

  const EntryWithAmount({
    required super.name,
    required super.value,
    required super.referenceValue,
    required super.weight,
    required super.costPerUnit,
    required this.amountAdded,
  });

  @override
  EntryWithAmount copyWith({
    String? name,
    double? value,
    double? referenceValue,
    double? weight,
    double? costPerUnit,
    double? amountAdded,
  }) {
    return EntryWithAmount(
      name: name ?? this.name,
      value: value ?? this.value,
      referenceValue: referenceValue ?? this.referenceValue,
      weight: weight ?? this.weight,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      amountAdded: amountAdded ?? this.amountAdded,
    );
  }

  @override
  String toString() {
    return 'EntryWithAmount{name: $name, value: $value, referenceValue: $referenceValue, '
        'weight: $weight, costPerUnit: $costPerUnit, amountAdded: $amountAdded}';
  }
}

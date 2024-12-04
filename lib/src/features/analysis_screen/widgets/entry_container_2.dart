import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/entry.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';

class EntryContainer2 extends StatelessWidget {
  final int entryNo;
  final Entry entry;

  const EntryContainer2({
    super.key,
    required this.entryNo,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double space1Width = 1;
    const double snWidth = 32;
    const double space1o2Width = 1;
    final double column1Width = screenWidth / 9;
    const double space2Width = 2;
    final double column2Width = screenWidth / 20;
    const double space3Width = 3;
    final double column3Width = screenWidth / 19;
    const double space4Width = 5;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 32,
          child: Row(
            children: [
              const SizedBox(width: space1Width),
              SizedBox(
                width: snWidth,
                child: Text(
                  '${entryNo.toString()}.',
                  style: const TextStyle(height: 1.1),
                ),
              ),
              const SizedBox(width: space1o2Width),
              SizedBox(
                width: column1Width,
                child: Text(
                  entry.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(height: 1.1),
                ),
              ),
              const SizedBox(width: space2Width),
              SizedBox(
                width: column2Width,
                child: Text(
                  entry.weight.formatToString,
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column2Width,
                child: Text(
                  entry.value.formatToString,
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column2Width,
                child: Text(
                  entry.referenceValue.formatToString,
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column3Width,
                child: Text(
                  '${(entry.answer * 100).toStringAsFixed(2)}%',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column2Width,
                child: Text(
                  entry.costPerUnit.formatToString,
                ),
              ),
              const SizedBox(width: space4Width),
            ],
          ),
        ),
      ],
    );
  }
}

class EntryReference2 extends StatelessWidget {
  const EntryReference2({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double space1Width = 1;
    const double snWidth = 32;
    const double space1o2Width = 1;
    final double column1Width = screenWidth / 9;
    const double space2Width = 2;
    final double column2Width = screenWidth / 20;
    const double space3Width = 3;
    final double column3Width = screenWidth / 19;
    const double space4Width = 5;

    return Row(
      children: [
        const SizedBox(width: space1Width + snWidth + space1o2Width),
        SizedBox(
          width: column1Width,
          child: const Text(
            'Entry Name',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: space2Width),
        SizedBox(
          width: column2Width,
          child: const Text(
            'Weight',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(width: space3Width),
        SizedBox(
          width: column2Width,
          child: const Text(
            'Value',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(width: space3Width),
        SizedBox(
          width: column2Width,
          child: const Text(
            'Reference',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(width: space3Width),
        SizedBox(
          width: column3Width,
          child: const Text(
            'Sub-total',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(width: space3Width),
        SizedBox(
          width: column2Width,
          child: const Text(
            'Cost per Unit',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: space4Width),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:formulator/src/features/analysis_screen/widgets/entry_container_2.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';

class SubsectionContainer2 extends StatelessWidget {
  final SubSection subSection;

  const SubsectionContainer2({super.key, required this.subSection});

  @override
  Widget build(BuildContext context) {
    late final String subSectionAnswer;
    try {
      subSectionAnswer = subSection.answer == subSection.answer.toInt()
          ? '${(subSection.answer.toInt() * 100).toString()}%'
          : '${(subSection.answer * 100).toStringAsFixed(3)}%';
    } catch (e) {
      subSectionAnswer = '---';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                subSection.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                ),
                child: Text(
                  '${subSection.weight.formatToString} '
                  '(${subSection.totalEntriesWeight.formatToString})',
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
              const SizedBox(width: 30),
              Text(
                'Sub-total: $subSectionAnswer',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const EntryReference2(),
          for (int i = 0; i < subSection.entries.length; i++)
            EntryContainer2(entryNo: i + 1, entry: subSection.entries[i]),
        ],
      ),
    );
  }
}

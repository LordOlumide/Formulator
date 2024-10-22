import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:formulator/src/features/formula_screen/widgets/entry_container.dart';

class SubsectionContainer extends StatelessWidget {
  final SubSection subSection;

  const SubsectionContainer({super.key, required this.subSection});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                subSection.name,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                ),
                child: Text(
                  subSection.weight.toString(),
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < subSection.entries.length; i++)
            EntryContainer(entry: subSection.entries[i]),
        ],
      ),
    );
  }
}

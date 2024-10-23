import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:formulator/src/features/formula_screen/widgets/subsection_container.dart';
import 'package:provider/provider.dart';

class SectionBody extends StatelessWidget {
  final ValueNotifier<String?> selectedSectionNotifier;
  final String formulaName;

  const SectionBody({
    super.key,
    required this.formulaName,
    required this.selectedSectionNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedSectionNotifier,
      builder: (context, selectedSectionName, child) {
        return Consumer<DBManager>(
          builder: (context, dbManager, child) {
            final Section section = dbManager.formulasMap[formulaName]!.sections
                .firstWhere((section) => section.name == selectedSectionName);
            final List<SubSection> subSections = section.subsections;

            return Column(
              children: [
                for (int i = 0; i < subSections.length; i++)
                  SubsectionContainer(
                    formulaName: formulaName,
                    sectionName: section.name,
                    subSection: section.subsections[i],
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

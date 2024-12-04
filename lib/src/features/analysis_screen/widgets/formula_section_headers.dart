import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/features/analysis_screen/widgets/section_container_2.dart';

class FormulaSectionHeaders extends StatelessWidget {
  final Formula formula;
  final ValueNotifier<String?> selectedSectionNotifier;

  const FormulaSectionHeaders({
    super.key,
    required this.formula,
    required this.selectedSectionNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (int i = 0; i < formula.sections.length; i++)
          ValueListenableBuilder(
            valueListenable: selectedSectionNotifier,
            builder: (context, selectedName, child) {
              return SectionContainer2(
                isSelected: formula.sections[i].name == selectedName,
                sectionName: formula.sections[i].name,
                sectionWeight: formula.sections[i].weight,
                subSectionTotalWeight:
                    formula.sections[i].totalSubSectionWeight,
                sectionAnswer: formula.sections[i].answer,
                onTap: () =>
                    selectedSectionNotifier.value = formula.sections[i].name,
              );
            },
          ),
      ],
    );
  }
}

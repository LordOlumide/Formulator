import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:formulator/src/features/analysis_screen/widgets/subsection_container_2.dart';

class SectionBody2 extends StatelessWidget {
  final Section selectedSection;

  const SectionBody2({super.key, required this.selectedSection});

  @override
  Widget build(BuildContext context) {
    final List<SubSection> subSections = selectedSection.subsections;

    return Column(
      children: [
        for (int i = 0; i < subSections.length; i++)
          SubsectionContainer2(
            subSection: selectedSection.subsections[i],
          ),
      ],
    );
  }
}

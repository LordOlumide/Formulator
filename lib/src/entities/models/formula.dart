import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/entry.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'formula.g.dart';

@HiveType(typeId: 0)
class Formula {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<Section> sections;

  const Formula({required this.name, required this.sections});

  List<String> get sectionNames =>
      sections.map((section) => section.name).toList();

  double get totalSectionWeight =>
      sections.fold(0, (prev, element) => prev + element.weight);

  double get answer => sections.fold<double>(
        0,
        (prev, element) =>
            prev + ((element.weight / totalSectionWeight) * element.answer),
      );

  static List<Color> colors = [
    Colors.green.shade800,
    Colors.blue.shade800,
    Colors.purple.shade800,
    Colors.orange.shade800,
    Colors.pink.shade800,
    Colors.red.shade800,
    Colors.cyan.shade800,
    Colors.amber.shade800,
  ];
  static double bracketFontSize = 30;
  static double fractionFontSize = 16;

  List<InlineSpan> get formulaDetails {
    List<InlineSpan> spans = [];

    int colorIndex = 0;
    for (Section section in sections) {
      spans.add(
        WidgetSpan(
          child: Column(
            children: [
              Text(
                section.weight.formatToString,
                style: TextStyle(
                    fontSize: fractionFontSize, fontWeight: FontWeight.w700),
              ),
              Container(width: 20, height: 3, color: Colors.black),
              Text(
                totalSectionWeight.formatToString,
                style: TextStyle(
                    fontSize: fractionFontSize, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
      spans.add(
        TextSpan(
          text: '( ',
          style:
              TextStyle(fontSize: bracketFontSize, fontWeight: FontWeight.w700),
        ),
      );
      for (SubSection subSection in section.subsections) {
        colorIndex < colors.length - 1 ? colorIndex += 1 : colorIndex = 0;
        final Color sectionColor = colors[colorIndex];

        spans.add(
          WidgetSpan(
            child: Column(
              children: [
                Text(
                  subSection.weight.formatToString,
                  style: TextStyle(fontSize: fractionFontSize),
                ),
                Container(width: 20, height: 3, color: Colors.black),
                Text(
                  section.totalSubSectionWeight.formatToString,
                  style: TextStyle(fontSize: fractionFontSize),
                ),
              ],
            ),
          ),
        );
        spans.add(
          TextSpan(
            text: '( ',
            style: TextStyle(fontSize: bracketFontSize),
          ),
        );
        for (Entry entry in subSection.entries) {
          spans.add(
            WidgetSpan(
              child: Column(
                children: [
                  Text(
                    entry.weight.formatToString,
                    style: TextStyle(fontSize: fractionFontSize),
                  ),
                  Container(width: 20, height: 3, color: Colors.black),
                  Text(
                    subSection.totalEntriesWeight.formatToString,
                    style: TextStyle(fontSize: fractionFontSize),
                  ),
                ],
              ),
            ),
          );
          spans.add(
            TextSpan(
              text: '(',
              style: TextStyle(fontSize: bracketFontSize, color: sectionColor),
            ),
          );
          spans.add(
            WidgetSpan(
              child: Column(
                children: [
                  Text(
                    entry.value.formatToString.toString(),
                    style: TextStyle(
                        fontSize: fractionFontSize, color: sectionColor),
                  ),
                  Container(width: 20, height: 3, color: sectionColor),
                  Text(
                    entry.referenceValue.formatToString.toString(),
                    style: TextStyle(
                        fontSize: fractionFontSize, color: sectionColor),
                  ),
                ],
              ),
            ),
          );
          spans.add(
            TextSpan(
              text: ')',
              style: TextStyle(fontSize: bracketFontSize, color: sectionColor),
            ),
          );
          spans.add(
            TextSpan(
              text: subSection.entries.indexOf(entry) <
                      subSection.entries.length - 1
                  ? '+'
                  : '',
              style: TextStyle(fontSize: bracketFontSize),
            ),
          );
        }
        spans.add(
          TextSpan(
            text:
                ' )${section.subsections.indexOf(subSection) < section.subsections.length - 1 ? ' + ' : ''}',
            style: TextStyle(fontSize: bracketFontSize),
          ),
        );
      }
      spans.add(
        TextSpan(
          text:
              ' )${sections.indexOf(section) < sections.length - 1 ? ' + ' : ''}',
          style: TextStyle(
            fontSize: bracketFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return spans;
  }

  /// To check if a subsection name already exists in a section
  bool doesSubExistInSection(String nameToCheck, String sectionNameToCheck) {
    Section sectionToCheck =
        sections.firstWhere((section) => section.name == sectionNameToCheck);
    for (SubSection subsection in sectionToCheck.subsections) {
      if (subsection.name == nameToCheck) {
        return true;
      }
    }
    return false;
  }

  /// To check if an entry name already exists in a sub-section
  bool doesEntryExistInSubSection(
    String nameToCheck,
    String sectionNameToCheck,
    String subSectionNameToCheck,
  ) {
    Section sectionToCheck =
        sections.firstWhere((section) => section.name == sectionNameToCheck);
    SubSection subSection = sectionToCheck.subsections
        .firstWhere((subSection) => subSection.name == subSectionNameToCheck);
    for (Entry entry in subSection.entries) {
      if (entry.name == nameToCheck) {
        return true;
      }
    }
    return false;
  }

  Formula copyWith({
    String? name,
    List<Section>? sections,
  }) {
    return Formula(
      name: name ?? this.name,
      sections: sections ?? this.sections,
    );
  }

  @override
  String toString() {
    return 'Formula{name: $name, sections: $sections}';
  }
}

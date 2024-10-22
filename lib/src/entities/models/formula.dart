import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
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

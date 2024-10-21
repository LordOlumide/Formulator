import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/features/formula_screen/widgets/create_or_edit_section_dialog.dart';
import 'package:formulator/src/features/formula_screen/widgets/section_container.dart';
import 'package:formulator/src/features/home_screen/widgets/yes_no_choice_dialog.dart';
import 'package:formulator/src/utils/functions/show_snackbar.dart';
import 'package:provider/provider.dart';

class FormulaScreen extends StatelessWidget {
  final String formulaName;

  const FormulaScreen({super.key, required this.formulaName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 20),
                Text(
                  formulaName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Consumer<DBManager>(
              builder:
                  (BuildContext context, DBManager manager, Widget? child) {
                final Formula formula = manager.formulasMap[formulaName]!;
                return SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 10),
                      for (int i = 0; i < formula.sections.length; i++)
                        SectionContainer(
                          sectionName: formula.sections[i].name,
                          onEditSectionPressed: () => _editSection(
                            context: context,
                            initialFormula: formula,
                            initialSectionName: formula.sections[i].name,
                          ),
                          onDeleteSectionPressed: () => _deleteSection(
                            context: context,
                            initialFormula: formula,
                            sectionToDeleteName: formula.sections[i].name,
                          ),
                        ),
                      IconButton(
                        color: Colors.blue,
                        onPressed: () => _addNewSection(context, formula),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addNewSection(
    BuildContext context,
    Formula initialFormula,
  ) async {
    late final Map<String, dynamic>? map;

    if (context.mounted) {
      map = await showDialog(
        context: context,
        builder: (context) {
          return const CreateOrEditSectionDialog();
        },
      );
    }
    if (map == null || map.isEmpty) return;

    if (context.mounted) {
      if (initialFormula.sectionNames.contains(map['name']!)) {
        UtilFunctions.showSnackBar(
          context,
          'Section already exists with this name!',
        );
        return;
      }
    }

    final Formula editedFormula = initialFormula.copyWith(
      sections: [
        ...initialFormula.sections,
        Section(
          name: map['name'],
          weight: double.parse(map['weight']),
          subsections: [],
        ),
      ],
    );

    if (context.mounted) {
      context.read<DBManager>().replaceFormula(
            formulaNameToReplace: editedFormula.name,
            replacementFormula: editedFormula,
          );
    }
  }

  Future<void> _editSection({
    required BuildContext context,
    required Formula initialFormula,
    required String initialSectionName,
  }) async {
    final List<Section> sections = initialFormula.sections;
    final Section sectionToEdit =
        sections.firstWhere((section) => section.name == initialSectionName);

    late final Map<String, dynamic>? map;
    if (context.mounted) {
      map = await showDialog(
        context: context,
        builder: (context) {
          return CreateOrEditSectionDialog(
            isCreateNotRename: false,
            initialNameValue: sectionToEdit.name,
            initialWeightValue: sectionToEdit.weight.toString(),
          );
        },
      );
    }
    if (map == null || map.isEmpty) return;

    if (context.mounted) {
      if (map['name'] != initialSectionName &&
          initialFormula.sectionNames.contains(map['name']!)) {
        UtilFunctions.showSnackBar(
          context,
          'Section already exists with this name!',
        );
        return;
      }

      final List<Section> newSections = [...initialFormula.sections];
      final int index = newSections
          .indexWhere((section) => section.name == initialSectionName);
      newSections.replaceRange(
        index,
        index + 1,
        [
          Section(
            name: map['name'],
            weight: double.parse(map['weight']),
            subsections: initialFormula.sections[index].subsections,
          ),
        ],
      );
      final Formula editedFormula =
          initialFormula.copyWith(sections: newSections);
      context.read<DBManager>().replaceFormula(
            formulaNameToReplace: editedFormula.name,
            replacementFormula: editedFormula,
          );
    }
  }

  Future<void> _deleteSection({
    required BuildContext context,
    required Formula initialFormula,
    required String sectionToDeleteName,
  }) async {
    late final bool? shouldDeleteSection;

    if (context.mounted) {
      shouldDeleteSection = await showDialog(
        context: context,
        builder: (context) {
          return YesNoChoiceDialog(
            title: 'Delete Section?',
            question: 'Are you sure you want to permanently delete '
                'the "$sectionToDeleteName" section?',
            noColor: Colors.black87,
            yesColor: Colors.red,
          );
        },
      );
    }
    if (shouldDeleteSection == null || shouldDeleteSection == false) return;

    if (context.mounted) {
      final List<Section> sections = [...initialFormula.sections];
      sections.removeWhere((section) => section.name == sectionToDeleteName);
      final Formula newFormula = initialFormula.copyWith(sections: sections);
      context.read<DBManager>().replaceFormula(
            formulaNameToReplace: initialFormula.name,
            replacementFormula: newFormula,
          );
    }
  }
}

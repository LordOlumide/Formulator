import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/entry.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:formulator/src/features/formula_screen/widgets/entry_container.dart';
import 'package:formulator/src/features/formula_screen/widgets/entry_dialog.dart';
import 'package:formulator/src/features/home_screen/widgets/yes_no_choice_dialog.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';
import 'package:formulator/src/utils/functions/show_snackbar.dart';
import 'package:formulator/src/utils/widgets/more_button.dart';
import 'package:provider/provider.dart';

class SubsectionContainer extends StatelessWidget {
  final String formulaName;
  final String sectionName;
  final SubSection subSection;

  const SubsectionContainer({
    super.key,
    required this.formulaName,
    required this.sectionName,
    required this.subSection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                ),
                child: Text(
                  '${subSection.weight.formatToString.toString()} '
                  '(${subSection.totalEntriesWeight.formatToString})',
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
              const Spacer(),
              MoreButton(
                options: [
                  MenuOption(
                    optionName: 'Add Entry',
                    icon: Icons.add,
                    function: () => _addEntry(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const EntryReference(),
          for (int i = 0; i < subSection.entries.length; i++)
            EntryContainer(
              formulaName: formulaName,
              sectionName: sectionName,
              subSectionName: subSection.name,
              entry: subSection.entries[i],
              deleteEntry: () =>
                  _deleteEntry(context, subSection.entries[i].name),
            ),
        ],
      ),
    );
  }

  Future<void> _addEntry(BuildContext context) async {
    final Formula initialFormula =
        context.read<DBManager>().formulasMap[formulaName]!;

    late final Map<String, dynamic>? map;

    if (context.mounted) {
      map = await showDialog(
        context: context,
        builder: (context) {
          return const EntryDialog();
        },
      );
    }
    if (map == null || map.isEmpty) return;

    if (context.mounted) {
      if (initialFormula.doesEntryExistInSubSection(
        map['name']!,
        sectionName,
        subSection.name,
      )) {
        UtilFunctions.showSnackBar(
          context,
          'Entry already exists with this name!',
        );
        return;
      }
    }

    final List<Section> newSections = [...initialFormula.sections];
    final SubSection sub = newSections
        .firstWhere((section) => section.name == sectionName)
        .subsections
        .firstWhere((element) => element.name == subSection.name);
    sub.entries.add(
      Entry(
        name: map['name'],
        value: double.parse(map['value']),
        referenceValue: double.parse(map['ref_value']),
        weight: double.parse(map['weight']),
      ),
    );

    if (context.mounted) {
      final Formula editedFormula =
          initialFormula.copyWith(sections: newSections);
      context.read<DBManager>().replaceFormula(
            formulaNameToReplace: editedFormula.name,
            replacementFormula: editedFormula,
          );
    }
  }

  Future<void> _deleteEntry(
      BuildContext context, String entryNameToDelete) async {
    final Formula initialFormula =
        context.read<DBManager>().formulasMap[formulaName]!;

    late final bool? shouldDeleteEntry;

    if (context.mounted) {
      shouldDeleteEntry = await showDialog(
        context: context,
        builder: (context) {
          return YesNoChoiceDialog(
            title: 'Delete Entry?',
            question: 'Are you sure you want to permanently delete '
                'the "$entryNameToDelete" section?',
            noColor: Colors.black87,
            yesColor: Colors.red,
          );
        },
      );
    }
    if (shouldDeleteEntry == null || shouldDeleteEntry == false) return;

    final List<Section> newSections = [...initialFormula.sections];
    final SubSection sub = newSections
        .firstWhere((section) => section.name == sectionName)
        .subsections
        .firstWhere((subSection) => subSection.name == subSection.name);
    sub.entries.removeWhere((entry) => entry.name == entryNameToDelete);

    if (context.mounted) {
      final Formula editedFormula =
          initialFormula.copyWith(sections: newSections);
      context.read<DBManager>().replaceFormula(
            formulaNameToReplace: editedFormula.name,
            replacementFormula: editedFormula,
          );
    }
  }
}

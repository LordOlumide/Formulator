import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/entry.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:formulator/src/features/formula_screen/widgets/entry_name_only_dialog.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';
import 'package:formulator/src/utils/functions/show_snackbar.dart';
import 'package:formulator/src/utils/widgets/more_button.dart';
import 'package:provider/provider.dart';

class EntryContainer extends StatefulWidget {
  final int entryNo;
  final String formulaName;
  final String sectionName;
  final String subSectionName;
  final Entry entry;
  final VoidCallback deleteEntry;

  const EntryContainer({
    super.key,
    required this.entryNo,
    required this.entry,
    required this.formulaName,
    required this.sectionName,
    required this.subSectionName,
    required this.deleteEntry,
  });

  @override
  State<EntryContainer> createState() => _EntryContainerState();
}

class _EntryContainerState extends State<EntryContainer> {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController refValueController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController costPerUnitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    valueController.text = widget.entry.value.formatToString;
    refValueController.text = widget.entry.referenceValue.formatToString;
    weightController.text = widget.entry.weight.formatToString;
    costPerUnitController.text = widget.entry.costPerUnit.formatToString;
  }

  @override
  void dispose() {
    valueController.dispose();
    refValueController.dispose();
    weightController.dispose();
    costPerUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double space1Width = 5;
    const double snWidth = 32;
    const double space1o2Width = 1;
    final double column1Width = screenWidth / 4;
    const double space2Width = 10;
    final double column2Width = screenWidth / 10;
    final double space3Width = screenWidth / 55;
    final double column3Width = screenWidth / 14;
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
                  '${widget.entryNo.toString()}.',
                  style: const TextStyle(height: 1.1),
                ),
              ),
              const SizedBox(width: space1o2Width),
              SizedBox(
                width: column1Width,
                child: Text(
                  widget.entry.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(height: 1.1),
                ),
              ),
              const SizedBox(width: space2Width),
              SizedBox(
                width: column2Width,
                child: _NumberInputField(
                  controller: weightController,
                  onChanged: (String? newString) =>
                      _onEdit(context, newString, _EditedVariable.weight),
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column2Width,
                child: _NumberInputField(
                  controller: valueController,
                  onChanged: (String? newString) =>
                      _onEdit(context, newString, _EditedVariable.value),
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column2Width,
                child: _NumberInputField(
                  controller: refValueController,
                  onChanged: (String? newString) =>
                      _onEdit(context, newString, _EditedVariable.refValue),
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column3Width,
                child: Text(
                  '${(widget.entry.answer * 100).toStringAsFixed(2)}%',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column2Width,
                child: _NumberInputField(
                  controller: costPerUnitController,
                  onChanged: (String? newString) =>
                      _onEdit(context, newString, _EditedVariable.costPerUnit),
                ),
              ),
              const SizedBox(width: space4Width),
              MoreButton(
                options: [
                  MenuOption(
                    optionName: 'Rename Entry',
                    icon: Icons.edit,
                    function: () => _onRenamePressed(context),
                  ),
                  MenuOption(
                    optionName: 'Delete Entry',
                    icon: Icons.delete_outline,
                    color: Colors.red,
                    function: widget.deleteEntry,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onRenamePressed(BuildContext context) async {
    late final String? newName;

    if (context.mounted) {
      newName = await showDialog(
        context: context,
        builder: (context) {
          return EntryNameOnlyDialog(initialName: widget.entry.name);
        },
      );
    }
    if (newName == null || newName.isEmpty) return;

    if (context.mounted) {
      _onEdit(context, newName, _EditedVariable.name);
    }
  }

  void _onEdit(
    BuildContext context,
    String? newString,
    _EditedVariable variable,
  ) {
    final Formula initialFormula =
        context.read<DBManager>().formulasMap[widget.formulaName]!;

    final List<Section> newSections = [...initialFormula.sections];
    final Section sectionToEdit =
        newSections.firstWhere((section) => section.name == widget.sectionName);
    final SubSection subSectionToEdit = sectionToEdit.subsections
        .firstWhere((sub) => sub.name == widget.subSectionName);
    final Entry entryToEdit = subSectionToEdit.entries
        .firstWhere((entry) => entry.name == widget.entry.name);

    final int sectionIndex =
        newSections.indexWhere((section) => section.name == widget.sectionName);
    final int subSectionIndex = newSections[sectionIndex]
        .subsections
        .indexWhere((sub) => sub.name == widget.subSectionName);
    final int entryIndex = newSections[sectionIndex]
        .subsections[subSectionIndex]
        .entries
        .indexWhere((entry) => entry.name == widget.entry.name);
    late final Entry newEntry;
    switch (variable) {
      case _EditedVariable.name:
        if (initialFormula.doesEntryExistInSubSection(
            newString!, sectionToEdit.name, subSectionToEdit.name)) {
          UtilFunctions.showSnackBar(
            context,
            'Entry already exists with this name!',
          );
          return;
        }
        newEntry = entryToEdit.copyWith(name: newString);
        break;
      case _EditedVariable.value:
        newEntry = entryToEdit.copyWith(
          value:
              int.parse(newString == '' || newString == null ? '0' : newString),
        );
        break;
      case (_EditedVariable.refValue):
        newEntry = entryToEdit.copyWith(
          referenceValue:
              int.parse(newString == '' || newString == null ? '0' : newString),
        );
        break;
      case _EditedVariable.weight:
        newEntry = entryToEdit.copyWith(
          weight: double.parse(
              newString == '' || newString == null ? '0' : newString),
        );
        break;
      case _EditedVariable.costPerUnit:
        newEntry = entryToEdit.copyWith(
          costPerUnit: double.parse(
              newString == '' || newString == null ? '0' : newString),
        );
        break;
    }
    newSections.replaceRange(
      sectionIndex,
      sectionIndex + 1,
      [
        sectionToEdit.copyWith(
          subsections: sectionToEdit.subsections
            ..replaceRange(
              subSectionIndex,
              subSectionIndex + 1,
              [
                subSectionToEdit.copyWith(
                  entries: subSectionToEdit.entries
                    ..replaceRange(
                      entryIndex,
                      entryIndex + 1,
                      [newEntry],
                    ),
                ),
              ],
            ),
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

enum _EditedVariable { name, value, refValue, weight, costPerUnit }

class EntryReference extends StatelessWidget {
  const EntryReference({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double space1Width = 5;
    const double snWidth = 32;
    const double space1o2Width = 1;
    final double column1Width = screenWidth / 4;
    const double space2Width = 10;
    final double column2Width = screenWidth / 10;
    final double space3Width = screenWidth / 55;
    final double column3Width = screenWidth / 14;
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

class _NumberInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?) onChanged;

  const _NumberInputField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        isCollapsed: true,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      ),
      onChanged: onChanged,
    );
  }
}

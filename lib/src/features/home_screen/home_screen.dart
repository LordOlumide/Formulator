import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/features/formula_screen/formula_screen.dart';
import 'package:formulator/src/features/home_screen/widgets/create_rename_formula_dialog.dart';
import 'package:formulator/src/features/home_screen/widgets/formula_container.dart';
import 'package:formulator/src/features/home_screen/widgets/yes_no_choice_dialog.dart';
import 'package:formulator/src/utils/functions/show_snackbar.dart';
import 'package:formulator/src/utils/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 2,
          // height: MediaQuery.sizeOf(context).height / 2,
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Formulator',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Consumer<DBManager>(
                  builder: (BuildContext context, DBManager dbManager,
                      Widget? child) {
                    return ListView(
                      children: [
                        for (int i = 0; i < dbManager.formulaCount; i++)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            child: FormulaContainer(
                              text: dbManager.formulaNames[i],
                              onPressed: () => _onFormulaPressed(
                                  context, dbManager.formulas[i]),
                              onRenamePressed: () => _onRenamePressed(
                                  context, dbManager.formulas[i]),
                              onDeletePressed: () => _onDeleteFormulaPressed(
                                  context, dbManager.formulaNames[i]),
                            ),
                          ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 40,
                          child: PrimaryButton(
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth / 10,
                            ),
                            onPressed: () =>
                                _onCreateNewFormulaPressed(context),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth / 40,
                              vertical: 10,
                            ),
                            child: const FittedBox(
                              child: Text(
                                'Create New Formula',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onCreateNewFormulaPressed(BuildContext context) async {
    late final String? newFormulaName;

    if (context.mounted) {
      newFormulaName = await showDialog(
        context: context,
        builder: (context) {
          return const CreateOrRenameFormulaDialog();
        },
      );
    }
    if (newFormulaName == null || newFormulaName.isEmpty) return;

    if (context.mounted) {
      if (context.read<DBManager>().formulaNames.contains(newFormulaName)) {
        UtilFunctions.showSnackBar(
          context,
          'Formula already exists with this name!',
        );
        return;
      }

      final Formula newFormula = Formula(
        name: newFormulaName,
        sections: [
          const Section(
            name: 'Section 1',
            weight: 1,
            subsections: [],
          ),
        ],
      );
      context.read<DBManager>().addFormula(newFormula);
    }
  }

  Future<void> _onRenamePressed(BuildContext context, Formula formula) async {
    late final String? newFormulaName;

    if (context.mounted) {
      newFormulaName = await showDialog(
        context: context,
        builder: (context) {
          return CreateOrRenameFormulaDialog(
            isCreateNotRename: false,
            initialValue: formula.name,
          );
        },
      );
    }
    if (newFormulaName == null || newFormulaName.isEmpty) return;

    if (context.mounted) {
      if (context.read<DBManager>().formulaNames.contains(newFormulaName)) {
        UtilFunctions.showSnackBar(
          context,
          'Formula already exists with this name!',
        );
        return;
      }

      final Formula newFormula = formula.copyWith(name: newFormulaName);
      context.read<DBManager>().replaceFormula(
            formulaNameToReplace: formula.name,
            replacementFormula: newFormula,
          );
    }
  }

  Future<void> _onDeleteFormulaPressed(
    BuildContext context,
    String formulaName,
  ) async {
    late final bool? shouldDeleteFormula;

    if (context.mounted) {
      shouldDeleteFormula = await showDialog(
        context: context,
        builder: (context) {
          return YesNoChoiceDialog(
            title: 'Delete Formula?',
            question: 'Are you sure you want to permanently delete '
                'the "$formulaName" formula?',
            noColor: Colors.black87,
            yesColor: Colors.red,
          );
        },
      );
    }
    if (shouldDeleteFormula == null) return;

    if (shouldDeleteFormula == true) {
      if (context.mounted) {
        context.read<DBManager>().deleteFormula(formulaName);
      }
    }
  }

  void _onFormulaPressed(BuildContext context, Formula formula) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FormulaScreen(formulaName: formula.name)),
    );
  }
}

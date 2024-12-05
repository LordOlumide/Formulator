import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/features/analysis_screen/analysis_comparison_screen.dart';
import 'package:formulator/src/features/analysis_screen/analysis_repo/analysis_repo.dart';
import 'package:formulator/src/features/analysis_screen/widgets/choose_analysis_dialog.dart';
import 'package:formulator/src/features/formula_screen/views/formula_display_section.dart';
import 'package:formulator/src/features/formula_screen/views/section_body.dart';
import 'package:formulator/src/features/formula_screen/views/section_headers.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';
import 'package:formulator/src/utils/functions/show_snackbar.dart';
import 'package:provider/provider.dart';

class FormulaScreen extends StatefulWidget {
  final String formulaName;

  const FormulaScreen({super.key, required this.formulaName});

  @override
  State<FormulaScreen> createState() => _FormulaScreenState();
}

class _FormulaScreenState extends State<FormulaScreen> {
  final ScrollController horizFormulaController = ScrollController();
  final ScrollController vertController = ScrollController();
  final ValueNotifier<String?> selectedSectionNotifier = ValueNotifier(null);

  Key _rebuildingKey = UniqueKey();

  bool screenIsLoading = false;

  void _onChangeSelectedSection() {
    setState(() {
      _rebuildingKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    _resetSelectedNotifier();
    selectedSectionNotifier.addListener(_onChangeSelectedSection);
  }

  void _resetSelectedNotifier([String? nameOfSectionAboutToBeDeleted]) {
    Formula initialFormula =
        context.read<DBManager>().formulasMap[widget.formulaName]!;
    final List<String> availableSections = initialFormula.sectionNames;

    if (nameOfSectionAboutToBeDeleted == null) {
      if (availableSections.isNotEmpty) {
        selectedSectionNotifier.value = availableSections[0];
      } else {
        selectedSectionNotifier.value = null;
      }
      return;
    }

    final int indexToBeDeleted =
        availableSections.indexOf(nameOfSectionAboutToBeDeleted);
    if (availableSections.isEmpty || availableSections.length == 1) {
      selectedSectionNotifier.value = null;
    } else {
      if (indexToBeDeleted > 0) {
        selectedSectionNotifier.value = availableSections[indexToBeDeleted - 1];
      } else if (availableSections.length - 1 > indexToBeDeleted) {
        selectedSectionNotifier.value = availableSections[indexToBeDeleted + 1];
      } else {
        selectedSectionNotifier.value = null;
      }
    }
  }

  @override
  void dispose() {
    horizFormulaController.dispose();
    vertController.dispose();
    selectedSectionNotifier.removeListener(_onChangeSelectedSection);
    selectedSectionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 20),
                FittedBox(
                  child: Text(
                    widget.formulaName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.fromLTRB(6, 1, 6, 5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Consumer<DBManager>(
                    builder: (context, manager, child) {
                      return Text(
                        '(${manager.formulasMap[widget.formulaName]!.totalSectionWeight.formatToString})',
                        style: const TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                MaterialButton(
                  color: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: const Text(
                    'Financial Analysis',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => _onFinancialAnalysisPressed(context),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormulaDisplaySection(
                  controller: horizFormulaController,
                  formulaName: widget.formulaName,
                ),
                const SizedBox(height: 4),
                SectionHeaders(
                  formulaName: widget.formulaName,
                  selectedSectionNotifier: selectedSectionNotifier,
                  resetSelectedNotifier: _resetSelectedNotifier,
                ),
                const SizedBox(height: 8),
                Expanded(
                  key: _rebuildingKey,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.04),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Scrollbar(
                      controller: vertController,
                      thumbVisibility: true,
                      thickness: 20,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 50, right: 20),
                        controller: vertController,
                        child: SectionBody(
                          formulaName: widget.formulaName,
                          selectedSectionNotifier: selectedSectionNotifier,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        screenIsLoading
            ? Positioned.fill(
                child: AbsorbPointer(
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Future<void> _onFinancialAnalysisPressed(BuildContext context) async {
    final Formula initialFormula =
        context.read<DBManager>().formulasMap[widget.formulaName]!;

    if (initialFormula.doesFormulaHaveEntries == false) {
      if (context.mounted) {
        UtilFunctions.showSnackBar(
          context,
          'Formula has no entries!',
        );
        return;
      }
    }

    late final Map<String, dynamic>? map;

    if (context.mounted) {
      map = await showDialog(
        context: context,
        builder: (context) {
          return const ChooseAnalysisDialog();
        },
      );
    }
    if (map == null || map.isEmpty) return;

    setState(() {
      screenIsLoading = true;
    });
    if (context.mounted) {
      late final Formula analyzedFormula;
      late final double totalCost;
      try {
        (analyzedFormula, totalCost) = map['analyseTo100percent'] == true
            ? AnalysisRepo.analyzeTo100Percent(initialFormula)
            : AnalysisRepo.analyzeWithAmount(initialFormula, map['amount']);
      } on Exception catch (_, e) {
        log(e.toString());
        print(e);
        print(_);
        UtilFunctions.showSnackBar(context, e.toString());
        return;
      }

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisComparisonScreen(
              oldFormula: initialFormula,
              newFormula: analyzedFormula,
              amountInputted:
                  map!['analyseTo100percent'] == true ? null : map['amount'],
              amountSpent: totalCost,
            ),
          ),
        );
      }
    }
    setState(() {
      screenIsLoading = false;
    });
  }
}

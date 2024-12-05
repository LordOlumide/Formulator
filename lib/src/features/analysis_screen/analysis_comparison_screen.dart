import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/features/analysis_screen/widgets/formula_analysis_view.dart';
import 'package:formulator/src/features/home_screen/widgets/create_rename_formula_dialog.dart';
import 'package:formulator/src/utils/functions/show_snackbar.dart';
import 'package:provider/provider.dart';

class AnalysisComparisonScreen extends StatefulWidget {
  final Formula oldFormula;
  final Formula newFormula;
  final double? amountInputted;
  final double amountSpent;

  const AnalysisComparisonScreen({
    super.key,
    required this.oldFormula,
    required this.newFormula,
    this.amountInputted,
    required this.amountSpent,
  });

  @override
  State<AnalysisComparisonScreen> createState() =>
      _AnalysisComparisonScreenState();
}

class _AnalysisComparisonScreenState extends State<AnalysisComparisonScreen> {
  final ScrollController leftScrollController = ScrollController();
  final ScrollController rightScrollController = ScrollController();
  final ValueNotifier<String?> selectedSectionNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    selectedSectionNotifier.value = widget.oldFormula.sectionNames[0];

    leftScrollController.addListener(_leftControllerListener);
    rightScrollController.addListener(_rightControllerListener);
  }

  void _leftControllerListener() {
    setState(() {
      rightScrollController.jumpTo(leftScrollController.offset);
    });
  }

  void _rightControllerListener() {
    setState(() {
      leftScrollController.jumpTo(rightScrollController.offset);
    });
  }

  @override
  void dispose() {
    leftScrollController.removeListener(_leftControllerListener);
    rightScrollController.removeListener(_rightControllerListener);
    leftScrollController.dispose();
    rightScrollController.dispose();
    selectedSectionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Total Spent = ${widget.amountSpent}',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 30),
            widget.amountInputted != null
                ? Text(
                    'Remainder = ${widget.amountInputted! - widget.amountSpent}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : const SizedBox.shrink(),
            const Spacer(),
            const Spacer(),
            MaterialButton(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: const Text(
                'Save New Formula',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onPressed: () => _onSaveAdjustedFormula(context),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: FormulaAnalysisView(
              title: 'Original formula',
              scrollController: leftScrollController,
              backgroundColor: Colors.red.withOpacity(0.1),
              formula: widget.oldFormula,
              selectedSectionNotifier: selectedSectionNotifier,
            ),
          ),
          Expanded(
            child: FormulaAnalysisView(
              title: 'Adjusted formula',
              scrollController: rightScrollController,
              backgroundColor: Colors.green.withOpacity(0.1),
              formula: widget.newFormula,
              selectedSectionNotifier: selectedSectionNotifier,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSaveAdjustedFormula(BuildContext context) async {
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

      final Formula newFormula =
          widget.newFormula.copyWith(name: newFormulaName);
      context.read<DBManager>().addFormula(newFormula);
    }
  }
}

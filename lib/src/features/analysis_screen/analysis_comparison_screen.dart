import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/features/analysis_screen/widgets/formula_analysis_view.dart';

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
            const SizedBox(width: 50),
            widget.amountInputted != null
                ? Text(
                    'Remainder = ${widget.amountInputted! - widget.amountSpent}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: FormulaAnalysisView(
              scrollController: leftScrollController,
              backgroundColor: Colors.red.withOpacity(0.1),
              formula: widget.oldFormula,
              selectedSectionNotifier: selectedSectionNotifier,
            ),
          ),
          Expanded(
            child: FormulaAnalysisView(
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
}

import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/formula.dart';

class AnalysisComparisonScreen extends StatelessWidget {
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
                'Total Spent = $amountSpent',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 50),
            amountInputted != null
                ? Text(
                    'Remainder = ${amountInputted! - amountSpent}',
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
            child: Container(
              color: Colors.red,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

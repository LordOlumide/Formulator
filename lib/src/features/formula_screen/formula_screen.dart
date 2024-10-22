import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/features/formula_screen/views/section_body.dart';
import 'package:formulator/src/features/formula_screen/views/section_headers.dart';
import 'package:provider/provider.dart';

class FormulaScreen extends StatefulWidget {
  final String formulaName;

  const FormulaScreen({super.key, required this.formulaName});

  @override
  State<FormulaScreen> createState() => _FormulaScreenState();
}

class _FormulaScreenState extends State<FormulaScreen> {
  final ValueNotifier<String?> selectedSectionNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    resetSelectedNotifier();
  }

  void resetSelectedNotifier() {
    Formula initialFormula =
        context.read<DBManager>().formulasMap[widget.formulaName]!;
    if (initialFormula.sections.isNotEmpty) {
      selectedSectionNotifier.value = initialFormula.sections[0].name;
    } else {
      selectedSectionNotifier.value = null;
    }
  }

  @override
  void dispose() {
    selectedSectionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  widget.formulaName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // TODO: Display total section weight
            const SizedBox(height: 60),
            SectionHeaders(
              formulaName: widget.formulaName,
              selectedSectionNotifier: selectedSectionNotifier,
              resetSelectedNotifier: resetSelectedNotifier,
            ),
            const SizedBox(height: 8),
            SectionBody(
              formulaName: widget.formulaName,
              selectedSectionNotifier: selectedSectionNotifier,
            ),
          ],
        ),
      ),
    );
  }
}

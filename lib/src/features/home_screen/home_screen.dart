import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/features/home_screen/widgets/formula_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Formulator',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            Consumer<DBManager>(
              builder:
                  (BuildContext context, DBManager dbManager, Widget? child) {
                return SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  height: MediaQuery.sizeOf(context).height / 2,
                  child: ListView(
                    children: [
                      for (int i = 0; i < dbManager.formulaCount; i++)
                        FormulaButton(
                          text: dbManager.formulas[i].name,
                          onPressed: () =>
                              _onFormulaPressed(dbManager.formulas[i]),
                        ),
                      ElevatedButton(
                        onPressed: () => _onCreateNewFormulaPressed,
                        child: Text(
                          'Create New Formula',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  void _onCreateNewFormulaPressed() {}

  void _onFormulaPressed(Formula formulaName) {}
}

import 'package:flutter/foundation.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DBManager extends ChangeNotifier {
  final Box<Formula> formulaBox;
  Map<String, Formula> _activeFormulas = {};

  Map<String, Formula> get formulasMap => _activeFormulas;
  List<Formula> get formulas => _activeFormulas.values.toList();
  List<String> get formulaNames => _activeFormulas.keys.toList();
  int get formulaCount => _activeFormulas.length;

  DBManager({required this.formulaBox}) {
    _refreshFormulasFromBox();
  }

  void _refreshFormulasFromBox() {
    _activeFormulas = Map<String, Formula>.from(formulaBox.toMap());
    notifyListeners();
    print(_activeFormulas);
  }

  void addFormula(Formula newFormula) {
    formulaBox.put(newFormula.name, newFormula);
    _refreshFormulasFromBox();
  }

  void replaceFormula({
    required String formulaNameToReplace,
    required Formula replacementFormula,
  }) {
    formulaBox.delete(formulaNameToReplace);
    formulaBox.put(replacementFormula.name, replacementFormula);
    _refreshFormulasFromBox();
  }

  void deleteFormula(String formulaName) {
    formulaBox.delete(formulaName);
    _refreshFormulasFromBox();
  }

  @override
  void dispose() {
    formulaBox.close();
    super.dispose();
  }
}

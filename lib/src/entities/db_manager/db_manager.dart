import 'package:flutter/foundation.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DBManager extends ChangeNotifier {
  final Box<Formula> formulaBox;
  List<Formula> _activeFormulas = [];

  List<Formula> get formulas => _activeFormulas;
  int get formulaCount => _activeFormulas.length;

  DBManager({required this.formulaBox}) {
    _refreshFormulasFromBox();
  }

  void _refreshFormulasFromBox() {
    _activeFormulas = formulaBox.values.toList();
    notifyListeners();
    print(_activeFormulas);
  }

  void addOrUpdateFormula(Formula newFormula) {
    formulaBox.put(newFormula.name, newFormula);
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

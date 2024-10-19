import 'package:flutter/material.dart';
import 'package:formulator/src/entities/app/formulator_app.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/entry.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(FormulaAdapter());
  Hive.registerAdapter(SectionAdapter());
  Hive.registerAdapter(SubSectionAdapter());
  Hive.registerAdapter(EntryAdapter());

  Box<Formula> formulaBox = await Hive.openBox<Formula>('formulas');
  runApp(
    ChangeNotifierProvider<DBManager>(
      create: (context) => DBManager(formulaBox: formulaBox),
      child: const FormulatorApp(),
    ),
  );
}

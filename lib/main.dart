import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formulator/src/entities/app/formulator_app.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/entities/models/entry.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(800, 650),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

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

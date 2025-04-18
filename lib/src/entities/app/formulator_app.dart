import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/features/home_screen/home_screen.dart';
import 'package:formulator/src/utils/constants/colors.dart';
import 'package:provider/provider.dart';

class FormulatorApp extends StatefulWidget {
  const FormulatorApp({super.key});

  @override
  State<FormulatorApp> createState() => _FormulatorAppState();
}

class _FormulatorAppState extends State<FormulatorApp> {
  @override
  void dispose() {
    context.read<DBManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulator',
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
      ),
      home: HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:formulator/src/entities/db_manager/db_manager.dart';
import 'package:formulator/src/utils/widgets/more_button.dart';
import 'package:provider/provider.dart';

class FormulaContainer extends StatelessWidget {
  final String formulaName;
  final double formulaAnswer;
  final VoidCallback onPressed;
  final VoidCallback onRenamePressed;
  final VoidCallback onDeletePressed;

  const FormulaContainer({
    super.key,
    required this.formulaName,
    required this.formulaAnswer,
    required this.onPressed,
    required this.onRenamePressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formulaName,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${(context.read<DBManager>().formulasMap[formulaName]!.answer * 100).toStringAsFixed(4)}%',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              MoreButton(
                options: [
                  MenuOption(
                    optionName: 'Rename Formula',
                    icon: Icons.drive_file_rename_outline,
                    function: onRenamePressed,
                  ),
                  MenuOption(
                    optionName: 'Delete Formula',
                    icon: Icons.delete_forever,
                    function: onDeletePressed,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

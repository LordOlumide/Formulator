import 'package:flutter/material.dart';
import 'package:formulator/src/utils/widgets/more_button.dart';

class FormulaContainer extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final VoidCallback onRenamePressed;
  final VoidCallback onDeletePressed;

  const FormulaContainer({
    super.key,
    required this.text,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
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

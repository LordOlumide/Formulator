import 'package:flutter/material.dart';
import 'package:formulator/src/utils/widgets/more_button.dart';

class SectionContainer extends StatelessWidget {
  final String sectionName;
  final VoidCallback onEditSectionPressed;
  final VoidCallback onDeleteSectionPressed;

  const SectionContainer({
    super.key,
    required this.sectionName,
    required this.onEditSectionPressed,
    required this.onDeleteSectionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 3, 8, 3),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(9),
          topLeft: Radius.circular(9),
          bottomRight: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          Text(
            sectionName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          MoreButton(
            options: [
              MenuOption(
                optionName: 'Edit Section',
                icon: Icons.drive_file_rename_outline,
                function: onEditSectionPressed,
              ),
              MenuOption(
                optionName: 'Delete Section',
                icon: Icons.delete_forever,
                function: onDeleteSectionPressed,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

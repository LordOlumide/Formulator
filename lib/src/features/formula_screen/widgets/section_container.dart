import 'package:flutter/material.dart';
import 'package:formulator/src/utils/widgets/more_button.dart';

class SectionContainer extends StatelessWidget {
  final bool isSelected;
  final String sectionName;
  final double sectionWeight;
  final VoidCallback onTap;
  final VoidCallback onAddSubSectionPressed;
  final VoidCallback onEditSectionPressed;
  final VoidCallback onDeleteSectionPressed;

  const SectionContainer({
    super.key,
    required this.isSelected,
    required this.sectionName,
    required this.sectionWeight,
    required this.onTap,
    required this.onAddSubSectionPressed,
    required this.onEditSectionPressed,
    required this.onDeleteSectionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 3, 8, 3),
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(9),
            topLeft: Radius.circular(9),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sectionName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black38 : Colors.blue.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                sectionWeight.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 5),
            MoreButton(
              options: [
                MenuOption(
                  optionName: 'Add New Sub-Section',
                  icon: Icons.add_box_outlined,
                  function: onAddSubSectionPressed,
                ),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';
import 'package:formulator/src/utils/widgets/more_button.dart';

class SectionContainer extends StatelessWidget {
  final bool isSelected;
  final String sectionName;
  final double sectionWeight;
  final double subSectionTotalWeight;
  final double sectionAnswer;
  final VoidCallback onTap;
  final VoidCallback onAddSubSectionPressed;
  final VoidCallback onEditSectionPressed;
  final VoidCallback onDeleteSectionPressed;

  const SectionContainer({
    super.key,
    required this.isSelected,
    required this.sectionName,
    required this.sectionWeight,
    required this.subSectionTotalWeight,
    required this.sectionAnswer,
    required this.onTap,
    required this.onAddSubSectionPressed,
    required this.onEditSectionPressed,
    required this.onDeleteSectionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final String ans = '${(sectionAnswer * 100).toStringAsFixed(3)}%';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        constraints: const BoxConstraints(maxWidth: 250),
        padding: const EdgeInsets.fromLTRB(12, 3, 8, 3),
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.black, width: 1),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(9),
            topLeft: Radius.circular(9),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      sectionName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${sectionWeight.formatToString.toString()} '
                      '(${subSectionTotalWeight.formatToString.toString()})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  isSelected
                      ? MoreButton(
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
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            Text(
              'Sub-total: $ans',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

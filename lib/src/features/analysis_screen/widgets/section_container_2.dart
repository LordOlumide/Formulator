import 'package:flutter/material.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';

class SectionContainer2 extends StatelessWidget {
  final bool isSelected;
  final String sectionName;
  final double sectionWeight;
  final double subSectionTotalWeight;
  final double sectionAnswer;
  final VoidCallback onTap;

  const SectionContainer2({
    super.key,
    required this.isSelected,
    required this.sectionName,
    required this.sectionWeight,
    required this.subSectionTotalWeight,
    required this.sectionAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String ans = '${(sectionAnswer * 100).toStringAsFixed(3)}%';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        constraints: const BoxConstraints(maxWidth: 160),
        padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          border: Border.all(
              color: isSelected ? Colors.blue : Colors.black, width: 1),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5),
            topLeft: Radius.circular(5),
            bottomRight: Radius.circular(3),
            bottomLeft: Radius.circular(3),
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
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sectionName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
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
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Sub-total: $ans',
              style: TextStyle(
                fontSize: 13,
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

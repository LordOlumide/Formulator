import 'package:flutter/material.dart';
import 'package:formulator/src/utils/widgets/primary_button.dart';

class YesNoChoiceDialog extends StatelessWidget {
  final String title;
  final String question;
  final Color noColor;
  final Color yesColor;

  const YesNoChoiceDialog({
    super.key,
    required this.title,
    required this.question,
    required this.noColor,
    required this.yesColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.lightBlue.shade50,
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width / 4,
      ),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.lightBlue, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              question,
              style: const TextStyle(
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryButton(
                  width: 100,
                  color: Colors.transparent,
                  onPressed: () => Navigator.pop(context, false),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: noColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  width: 100,
                  color: Colors.transparent,
                  onPressed: () => Navigator.pop(context, true),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: yesColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

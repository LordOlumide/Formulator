import 'package:flutter/material.dart';
import 'package:formulator/src/utils/widgets/primary_button.dart';

class CreateFormulaDialog extends StatelessWidget {
  const CreateFormulaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.lightBlue.shade50,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
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
            const Text(
              'Create New Formula',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            ///
            ///
            ///
            ///
            const SizedBox(height: 25),
            PrimaryButton(
              shrink: true,
              color: Colors.blue,
              onPressed: Navigator.of(context).pop,
              borderRadius: BorderRadius.circular(35),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 20),
              child: const Text(
                'Okay',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

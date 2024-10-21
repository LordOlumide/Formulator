import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formulator/src/utils/widgets/primary_button.dart';

class CreateOrEditSectionDialog extends StatefulWidget {
  final bool isCreateNotRename;
  final String? initialNameValue;
  final String? initialWeightValue;

  const CreateOrEditSectionDialog({
    super.key,
    this.isCreateNotRename = true,
    this.initialNameValue,
    this.initialWeightValue,
  });

  @override
  State<CreateOrEditSectionDialog> createState() =>
      _CreateOrEditSectionDialogState();
}

class _CreateOrEditSectionDialogState extends State<CreateOrEditSectionDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  final FocusNode firstFocusNode = FocusNode();
  final FocusNode secondFocusNode = FocusNode();
  final FocusNode thirdFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialNameValue != null) {
      nameController.text = widget.initialNameValue!;
    }
    if (widget.initialWeightValue != null) {
      weightController.text = widget.initialWeightValue!;
    } else {
      weightController.text = '1';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    weightController.dispose();
    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    super.dispose();
  }
  // TODO: CHECK IF EMPTY

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.lightBlue.shade50,
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width / 3,
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
              widget.isCreateNotRename ? 'Create New Section' : 'Edit Section',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Section Name',
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              autofocus: true,
              focusNode: firstFocusNode,
              controller: nameController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(secondFocusNode);
              },
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Section Weight',
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              focusNode: secondFocusNode,
              controller: weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(thirdFocusNode);
              },
            ),
            const SizedBox(height: 25),
            PrimaryButton(
              focusNode: thirdFocusNode,
              shrink: true,
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop({
                  'name': nameController.text,
                  'weight': weightController.text,
                });
              },
              borderRadius: BorderRadius.circular(35),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 20),
              child: Text(
                widget.isCreateNotRename ? 'Create' : 'Edit',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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

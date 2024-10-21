import 'package:flutter/material.dart';
import 'package:formulator/src/utils/extensions/string_extension.dart';
import 'package:formulator/src/utils/widgets/primary_button.dart';

class CreateOrRenameFormulaDialog extends StatefulWidget {
  final bool isCreateNotRename;
  final String? initialValue;

  const CreateOrRenameFormulaDialog({
    super.key,
    this.isCreateNotRename = true,
    this.initialValue,
  });

  @override
  State<CreateOrRenameFormulaDialog> createState() =>
      _CreateOrRenameFormulaDialogState();
}

class _CreateOrRenameFormulaDialogState
    extends State<CreateOrRenameFormulaDialog> {
  final TextEditingController nameController = TextEditingController();

  final FocusNode firstFocusNode = FocusNode();
  final FocusNode secondFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      nameController.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    firstFocusNode.dispose();
    secondFocusNode.dispose();
    super.dispose();
  }

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
              widget.isCreateNotRename
                  ? 'Create New Formula'
                  : 'Rename Formula',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Formula Name',
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
            const SizedBox(height: 25),
            PrimaryButton(
              shrink: true,
              focusNode: secondFocusNode,
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context)
                    .pop(nameController.text.toFirstUpperCase());
              },
              borderRadius: BorderRadius.circular(35),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 20),
              child: Text(
                widget.isCreateNotRename ? 'Create' : 'Rename',
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

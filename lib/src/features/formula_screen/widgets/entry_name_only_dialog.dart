import 'package:flutter/material.dart';
import 'package:formulator/src/utils/functions/validators.dart';
import 'package:formulator/src/utils/widgets/primary_button.dart';

class EntryNameOnlyDialog extends StatefulWidget {
  final String initialName;

  const EntryNameOnlyDialog({super.key, required this.initialName});

  @override
  State<EntryNameOnlyDialog> createState() => _EntryNameOnlyDialogState();
}

class _EntryNameOnlyDialogState extends State<EntryNameOnlyDialog> {
  final TextEditingController nameController = TextEditingController();

  final FocusNode firstFocusNode = FocusNode();
  final FocusNode secondFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.initialName;
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Rename Entry',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 25),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(height: 4),
              TextFormField(
                autofocus: true,
                focusNode: firstFocusNode,
                controller: nameController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => Validators.simpleValidator(value),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(secondFocusNode);
                },
              ),
              const SizedBox(height: 25),
              PrimaryButton(
                focusNode: secondFocusNode,
                shrink: true,
                color: Colors.blue,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop(nameController.text);
                  }
                },
                borderRadius: BorderRadius.circular(35),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 20),
                child: const Text(
                  'Rename',
                  style: TextStyle(
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:formulator/src/entities/models/entry.dart';

class EntryContainer extends StatefulWidget {
  final Entry entry;

  const EntryContainer({super.key, required this.entry});

  @override
  State<EntryContainer> createState() => _EntryContainerState();
}

class _EntryContainerState extends State<EntryContainer> {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController referenceValueController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    valueController.text = widget.entry.value.toString();
    referenceValueController.text = widget.entry.referenceValue.toString();
    weightController.text = widget.entry.weight.toString();
  }

  @override
  void dispose() {
    valueController.dispose();
    referenceValueController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Row(
        children: [
          Text(
            widget.entry.name,
            style: TextStyle(),
          ),
        ],
      ),
    );
  }
}

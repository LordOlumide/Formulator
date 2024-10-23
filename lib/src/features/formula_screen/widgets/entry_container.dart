import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formulator/src/entities/models/entry.dart';
import 'package:formulator/src/utils/extensions/number_extension.dart';

class EntryContainer extends StatefulWidget {
  final String formulaName;
  final String sectionName;
  final String subSectionName;
  final Entry entry;

  const EntryContainer({
    super.key,
    required this.entry,
    required this.formulaName,
    required this.sectionName,
    required this.subSectionName,
  });

  @override
  State<EntryContainer> createState() => _EntryContainerState();
}

class _EntryContainerState extends State<EntryContainer> {
  final TextEditingController valueController = TextEditingController();
  final TextEditingController refValueController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    valueController.text = widget.entry.value.formatToString;
    refValueController.text = widget.entry.referenceValue.formatToString;
    weightController.text = widget.entry.weight.formatToString;
  }

  @override
  void dispose() {
    valueController.dispose();
    refValueController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double space1Width = 14;
    final double column1Width = screenWidth / 3;
    const double space2Width = 10;
    final double column2Width = screenWidth / 8;
    final double space3Width = screenWidth / 15;
    const double space4Width = 10;

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              const SizedBox(width: space1Width),
              SizedBox(
                width: column1Width,
                child: Text(
                  widget.entry.name,
                  style: const TextStyle(),
                ),
              ),
              const SizedBox(width: space2Width),
              SizedBox(
                width: column2Width,
                child: _NumberInputField(
                  controller: valueController,
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column2Width,
                child: _NumberInputField(
                  controller: refValueController,
                ),
              ),
              SizedBox(width: space3Width),
              SizedBox(
                width: column2Width,
                child: _NumberInputField(
                  controller: weightController,
                ),
              ),
              const SizedBox(width: space4Width),
            ],
          ),
        ),
      ],
    );
  }
}

class EntryReference extends StatelessWidget {
  const EntryReference({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double space1Width = 14;
    final double column1Width = screenWidth / 3;
    const double space2Width = 10;
    final double column2Width = screenWidth / 8;
    final double space3Width = screenWidth / 15;
    const double space4Width = 10;

    return Row(
      children: [
        const SizedBox(width: space1Width),
        SizedBox(
          width: column1Width,
          child: const Text(
            'Entry Name',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: space2Width),
        SizedBox(
          width: column2Width,
          child: const Text(
            'Value',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: space3Width),
        SizedBox(
          width: column2Width,
          child: const Text(
            'Reference',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: space3Width),
        SizedBox(
          width: column2Width,
          child: const Text(
            'Weight',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: space4Width),
      ],
    );
  }
}

class _NumberInputField extends StatelessWidget {
  final TextEditingController controller;

  const _NumberInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        isCollapsed: true,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      ),
      onChanged: (String? newValue) {},
    );
  }
}

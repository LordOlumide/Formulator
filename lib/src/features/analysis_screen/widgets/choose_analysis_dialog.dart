import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formulator/src/utils/functions/validators.dart';
import 'package:formulator/src/utils/widgets/primary_button.dart';
import 'package:intl/intl.dart';

class ChooseAnalysisDialog extends StatefulWidget {
  const ChooseAnalysisDialog({super.key});

  @override
  State<ChooseAnalysisDialog> createState() => _ChooseAnalysisDialogState();
}

class _ChooseAnalysisDialogState extends State<ChooseAnalysisDialog> {
  final PageController pageController = PageController();

  final FocusNode amountTextFieldFocusNode = FocusNode();
  final FocusNode calculateWithAmountButtonFocusNode = FocusNode();

  final TextEditingController amountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? amountString;

  @override
  void dispose() {
    pageController.dispose();
    amountTextFieldFocusNode.dispose();
    calculateWithAmountButtonFocusNode.dispose();
    amountController.dispose();
    super.dispose();
  }

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
        height: 400,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: PageView(
          controller: pageController,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Choose Analysis Mode',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ),
                const Spacer(flex: 2),
                PrimaryButton(
                  onPressed: () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.linear,
                    );
                  },
                  child: const Text(
                    'Analyse with specific amount',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  onPressed: _analyseTo100Percent,
                  child: const Text(
                    'Analyse to 100% completion',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.linear,
                          );
                        },
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Input available amount',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  const Text(
                    'Note: The algorithm assigns money to the entries with the '
                    'lowest percentages first until they reach the same '
                    'percentage as the second lowest. This is repeated until the '
                    'money runs out or all entries are at 100%. For entries with '
                    'equal percentage, weight is prioritized.'
                    '\nPercentage = (value / reference) * 100%',
                    textAlign: TextAlign.justify,
                    style: TextStyle(height: 1.3, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    autofocus: true,
                    focusNode: amountTextFieldFocusNode,
                    controller: amountController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 19),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) => Validators.simpleValidator(value),
                    onChanged: (String? newString) {
                      setState(() {
                        amountString = (newString == null || newString == '')
                            ? '0'
                            : NumberFormat.decimalPattern()
                                .format(double.parse(newString));
                      });
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(calculateWithAmountButtonFocusNode);
                    },
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    shrink: true,
                    onPressed: _analyseWithAmount,
                    focusNode: calculateWithAmountButtonFocusNode,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Analyse with ${amountString ?? '0'}',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _analyseTo100Percent() {
    Navigator.of(context).pop({
      'analyseTo100percent': true,
    });
  }

  void _analyseWithAmount() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'analyseTo100percent': false,
        'amount': double.parse(amountController.text),
      });
    }
  }
}

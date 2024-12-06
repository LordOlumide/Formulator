import 'dart:math';

import 'package:formulator/src/entities/models/entry.dart';
import 'package:formulator/src/entities/models/formula.dart';
import 'package:formulator/src/entities/models/section.dart';
import 'package:formulator/src/entities/models/sub_section.dart';
import 'package:formulator/src/features/analysis_screen/models/detailed_entry.dart';
import 'package:formulator/src/features/analysis_screen/models/entry_with_amount.dart';

class AnalysisRepo {
  /// Returns the 100% formula and the cost of achieving it
  static (Formula, double) analyzeTo100Percent(
    Formula initialFormula,
  ) {
    double totalCost = 0;
    final newFormula = Formula(name: initialFormula.name, sections: []);

    for (Section section in initialFormula.sections) {
      final Section newSection =
          Section(name: section.name, weight: section.weight, subsections: []);

      for (SubSection subSection in section.subsections) {
        final SubSection newSubsection = SubSection(
          name: subSection.name,
          weight: subSection.weight,
          entries: [],
        );

        for (Entry entry in subSection.entries) {
          late final EntryWithAmount newEntry;
          if (entry.value >= entry.referenceValue) {
            newEntry = EntryWithAmount(
              name: entry.name,
              value: entry.value,
              referenceValue: entry.referenceValue,
              weight: entry.weight,
              costPerUnit: entry.costPerUnit,
              amountAdded: null,
            );
          } else {
            final double units = entry.referenceValue - entry.value;
            final double cost = units * entry.costPerUnit;
            totalCost += cost;

            newEntry = EntryWithAmount(
              name: entry.name,
              value: entry.value < entry.referenceValue
                  ? entry.referenceValue
                  : entry.value,
              referenceValue: entry.referenceValue,
              weight: entry.weight,
              costPerUnit: entry.costPerUnit,
              amountAdded: cost,
            );
          }

          newSubsection.entries.add(newEntry);
        }

        newSection.subsections.add(newSubsection);
      }

      newFormula.sections.add(newSection);
    }

    return (newFormula, totalCost);
  }

  static (Formula, double) analyzeWithAmount(
    Formula initialFormula,
    double availableAmount,
  ) {
    double amountSpent = 0;

    final List<DetailedEntry> completedDetailedEntries = [];
    final List<DetailedEntry> initialDetailedEntries =
        _getDetailedEntries(initialFormula);

    void moveEntryFromInitialToCompleted(DetailedEntry entry) {
      final int indexOfEntry = initialDetailedEntries.indexWhere(
          (DetailedEntry e) =>
              e.name == entry.name &&
              e.sectionName == entry.sectionName &&
              e.subSectionName == entry.subSectionName);
      final newEntry = initialDetailedEntries.removeAt(indexOfEntry);
      completedDetailedEntries.add(newEntry);
    }

    while (true) {
      late final double lowestAnswer;
      late double secondLowestAnswer;

      late final List<DetailedEntry> entriesWithLowestAnswer;

      if (initialDetailedEntries.length > 1) {
        (lowestAnswer, secondLowestAnswer) =
            _getLowestAndSecondLowestAnswers(initialDetailedEntries);
        entriesWithLowestAnswer = initialDetailedEntries
            .where((DetailedEntry entry) => entry.answer == lowestAnswer)
            .toList();
        entriesWithLowestAnswer
            .sort((a, b) => b.impactOnFormula.compareTo(a.impactOnFormula));
      } else if (initialDetailedEntries.length == 1) {
        lowestAnswer = initialDetailedEntries[0].answer;
        secondLowestAnswer = 1;
        entriesWithLowestAnswer = [initialDetailedEntries[0]];
      } else {
        throw Exception('There are no entries in the formula!');
      }

      if (lowestAnswer == secondLowestAnswer && lowestAnswer < 1) {
        secondLowestAnswer = 1;
      }

      for (DetailedEntry entry in entriesWithLowestAnswer) {
        if (entry.answer >= 1) {
          moveEntryFromInitialToCompleted(entry);
          continue;
        }

        if (availableAmount >= entry.costPerUnit) {
          final double unitsToAdd = entry.referenceValue - entry.value < 1
              ? entry.referenceValue - entry.value
              : entry.value % 1 == 0
                  ? 1
                  : entry.value % 1;
          final double cost = unitsToAdd * entry.costPerUnit;

          final int indexOfEntry = initialDetailedEntries
              .indexWhere((DetailedEntry e) => e.name == entry.name);
          final DetailedEntry newEntry = entry.copyWith(
            newValue: initialDetailedEntries[indexOfEntry].value + unitsToAdd,
          );
          initialDetailedEntries.replaceRange(
            indexOfEntry,
            indexOfEntry + 1,
            [newEntry],
          );
          availableAmount -= cost;
          amountSpent += cost;

          if (initialDetailedEntries[indexOfEntry].answer >= 1) {
            moveEntryFromInitialToCompleted(newEntry);
          }
        } else {
          moveEntryFromInitialToCompleted(entry);
        }
      }

      if (initialDetailedEntries.isEmpty) {
        return (
          _getNewFormulaObjectFromDetailedEntries(
            initialFormula: initialFormula,
            detailedEntries: completedDetailedEntries,
          ),
          amountSpent,
        );
      }
    }
  }

  static List<DetailedEntry> _getDetailedEntries(Formula initialFormula) {
    final List<DetailedEntry> detailedEntries = [];
    for (Section section in initialFormula.sections) {
      for (SubSection subSection in section.subsections) {
        for (Entry entry in subSection.entries) {
          detailedEntries.add(
            DetailedEntry(
              name: entry.name,
              value: entry.value,
              referenceValue: entry.referenceValue,
              weight: entry.weight,
              costPerUnit: entry.costPerUnit,
              answer: entry.value / entry.referenceValue,
              subSectionName: subSection.name,
              sectionName: section.name,
              impactOnFormula: ((entry.weight / subSection.totalEntriesWeight) /
                      section.totalSubSectionWeight) /
                  initialFormula.totalSectionWeight,
            ),
          );
        }
      }
    }
    return detailedEntries;
  }

  static (double lowest, double secondLowest) _getLowestAndSecondLowestAnswers(
    List<DetailedEntry> detailedEntries,
  ) {
    double lowest = detailedEntries.map((e) => e.answer).toList().reduce(max);
    double secondLowest = double.infinity;

    for (DetailedEntry entry in detailedEntries) {
      if (entry.answer < lowest ||
          (entry.answer == lowest && secondLowest == double.infinity)) {
        secondLowest = lowest;
        lowest = entry.answer;
      } else if (entry.answer < secondLowest && entry.answer != lowest) {
        secondLowest = entry.answer;
      }
    }
    if (secondLowest == double.infinity || lowest == double.infinity) {
      throw Exception(
          '======= There are less than 2 entries in the formula! =======');
    }
    return (lowest, secondLowest);
  }

  static Formula _getNewFormulaObjectFromDetailedEntries({
    required Formula initialFormula,
    required List<DetailedEntry> detailedEntries,
  }) {
    final Formula newFormula = Formula(
      name: initialFormula.name,
      sections: initialFormula.sections
          .map(
            (Section section) => Section(
              name: section.name,
              weight: section.weight,
              subsections: section.subsections
                  .map(
                    (SubSection subSection) => SubSection(
                      name: subSection.name,
                      weight: subSection.weight,
                      entries: [],
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );

    for (Section section in initialFormula.sections) {
      for (SubSection subSection in section.subsections) {
        for (Entry entry in subSection.entries) {
          newFormula.sections
              .firstWhere((Section s) => s.name == section.name)
              .subsections
              .firstWhere((SubSection sub) => sub.name == subSection.name)
              .entries
              .add(
            () {
              DetailedEntry detailedEntry = detailedEntries.firstWhere(
                  (DetailedEntry d) =>
                      d.name == entry.name &&
                      d.subSectionName == subSection.name &&
                      d.sectionName == section.name);

              final double unitsAdded = detailedEntry.value - entry.value;
              final double cost = unitsAdded * entry.costPerUnit;

              return EntryWithAmount(
                name: detailedEntry.name,
                value: detailedEntry.value,
                referenceValue: detailedEntry.referenceValue,
                weight: detailedEntry.weight,
                costPerUnit: detailedEntry.costPerUnit,
                amountAdded: cost,
              );
            }(),
          );
        }
      }
    }

    return newFormula;
  }
}

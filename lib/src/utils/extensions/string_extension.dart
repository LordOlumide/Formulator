extension StringExtension on String {
  String toFirstUpperCase() {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();

    final List<String> wordList = split(' ');
    return wordList
        .map((word) {
          if (word.isEmpty) return '';
          if (word.length == 1) return word.toUpperCase();
          return word.startsWith('"') ||
                  word.startsWith("'") ||
                  word.startsWith('`')
              ? '${word.substring(0, 2).toUpperCase()}${word.substring(2).toLowerCase()}'
              : '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .toList()
        .join(' ');
  }

  bool get isDigit => double.tryParse(this) != null;

  String get cleanLower => trim().toLowerCase();

  String get possessive => chars.last == 's' ? '$this\'' : '$this\'s';

  String get cleanUpper => trim().toUpperCase();

  String removeAll(String pattern) {
    return replaceAll(pattern, '');
  }

  String removeAtLast(String pattern) {
    if (chars.last == pattern) {
      return substring(0, length - 1);
    }
    return this;
  }

  String? get nullIfEmpty => isEmpty ? null : this;

  String get reversed => chars.reversed.join();

  String removeAllAtLast(List<String> patterns) {
    String result = this;
    for (final String pattern in patterns) {
      result = result.removeAtLast(pattern);
      return result;
    }
    return result;
  }

  List<String> get words => split(' ');

  String toEachFirstUpperCase() {
    if (isEmpty) return '';
    if (length == 1) return toUpperCase();
    final List<String> upperWords = words.map((e) {
      return e.toFirstUpperCase();
    }).toList();
    return upperWords.join(' ');
  }

  String get linesRemoved => removeAll('\n');

  List<String> get chars => split('');

  String withExcludeParam(String param) {
    final String queryParam = 'exclude=$param';
    return addParam(queryParam);
  }

  String addParam(String param) {
    if (contains('?')) return '$this&$param';
    return '$this?$param';
  }

  String replaceLast(String from, String to, [int startIndex = 0]) {
    for (int i = (length - 1); i >= startIndex; i--) {
      if (this[i] == from) {
        return replaceRange(i, i + 1, to);
      }
    }
    return this;
  }

  String clipToIfLonger(int num) => substring(0, num > length ? length : num);

  bool get startsWithInteger => RegExp(r'^\d').hasMatch(this);

  int? get extractInitialInteger {
    RegExp regExp = RegExp(r'^\d+');
    Match? match = regExp.firstMatch(this);

    if (match != null) {
      return int.parse(match.group(0)!);
    }

    return null;
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  bool get isNotNullOrEmpty => this?.isNotEmpty ?? false;

  String? get nullIfEmpty => isNullOrEmpty ? null : this;
}

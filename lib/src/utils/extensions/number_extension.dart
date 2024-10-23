import 'dart:math' as math;

extension NumExtension on num {
  ///returns value * (percentage/100)
  double percent(num percentage) => (this * (percentage / 100)).toDouble();

  num get nonNegative => (this < 0) ? 0 : this;

  num? get isZeroNull => this == 0 ? null : this;

  bool get isFiveMultiple => this % 5 == 0;

  double get negate => this * -1;

  String get pluralS => this == 1 ? '' : 's';

  String get textVowelPlural => this == 1 ? '' : 'es';

  double get half => this / 2;

  double get sixth => this / 6;

  double get third => this / 3;

  double get twoThirds => this * 2 / 3;

  double get doubled => this * 2;

  double ratio(double value) => this * value;

  double get toRadians => this * (math.pi / 180);

  double get pi => this * math.pi;

  double get degreesToPi => this * (math.pi / 180);

  String get formatToString =>
      this == toInt() ? toInt().toString() : toString();

  double roundDown(int precision) {
    final isNegative = this.isNegative;
    final mod = math.pow(10.0, precision);
    final roundDown = (((abs() * mod).floor()) / mod);
    return isNegative ? -roundDown : roundDown;
  }
}

extension IntExtension on int {
  List<int> range([int start = 1]) => List<int>.generate(
        this,
        (int index) => index + start,
      );

  Duration get seconds => Duration(seconds: this);

  int? get nullIfZero => this == 0 ? null : this;

  bool get isSingleDigit => this > -1 && this <= 9;
}

extension NullableIntExtension on int? {
  bool get isSingleDigitOrNull {
    if (this == null) return true;
    if (this != null) {
      if (this! > -1 && this! <= 9) return true;
    }
    return false;
  }
}

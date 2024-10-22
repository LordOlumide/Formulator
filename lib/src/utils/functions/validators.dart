abstract class Validators {
  static String? simpleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty.';
    }
    return null;
  }
}

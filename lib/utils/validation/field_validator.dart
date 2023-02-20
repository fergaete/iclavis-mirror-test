abstract class FieldValidator {
  static String _prefix = "http://";

  static RegExp _urlRegExp = RegExp(
    r"^(http|https)://",
    caseSensitive: false,
    multiLine: false,
  );

  static RegExp _pathRegExp = RegExp(
    r"(\w||-||_|| ){1,}.\w{1,}$",
    caseSensitive: false,
    multiLine: false,
  );

  static RegExp _emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  //r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[/\W|_/g])[A-Za-z\d/\W|_/g]{8,}$"  special char
  //^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d/\W|_/g]{8,}$ no special char
  //r"^.{8,}$" max length 8
  static RegExp _passwordRegExp =
      RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d/\W|_/g]{8,}$");

  static bool email(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static bool password(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}

/* extension StringExtension on String {
  get firstLetterToUpperCase {
    if (this != null)
      return this[0].toUpperCase() + this.substring(1);
    else
      return null;
  }
} */

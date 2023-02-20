class NameUtil {
  static String shortName(String name) {
    if (name.length >= 5 && name.contains('.')) {
      return name.split('.')[1].trim();
    }
    return name.length > 12 ? name.substring(0, 12) : name;
  }
}

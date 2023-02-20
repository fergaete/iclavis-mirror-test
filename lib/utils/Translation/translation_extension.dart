import 'translation.dart';

extension TranslationExtension on String {
  String get i18n => Translation.inst.translate(this);
}

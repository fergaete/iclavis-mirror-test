import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';

import 'property_service.dart';

class PropertyRepository {
  final _propertyService = PropertyService();
  final _handler = ExceptionHandler();

  Future<Result> fetchProperties({ required String dni, required int id,required String apiKey}) async {

    try {
      PropertyModel? storedProperty = await _readProperty(id);

      if (storedProperty != null) {
        return Result(data: storedProperty);
      }
      final property = await _propertyService.fetchProperty(
        dni,
        id,
        apiKey,
      );

      await _writeProperty(json.encode(property), id);

      return Result(data: property);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }

  Future<PropertyModel?> _readProperty(int projectId) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();

    String? storedProperty;
    PropertyModel? property;
    try {
      storedProperty = prefs.getString("property_$projectId");
      property = PropertyModel.fromJson(json.decode(storedProperty!));
    } catch (e) {
      return null;
    }
    return property;
  }

  Future _writeProperty(String property, int projectId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("property_$projectId", property);
  }

  static Future removeProperties() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys().where((e) => e.contains('property'));

    keys.forEach((e) {
      prefs.remove(e);
    });
  }
}

import 'dart:convert';
import 'package:iclavis/services/property/property_repository.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/utils/http/result.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository _propertyRepository = PropertyRepository();
  PropertyBloc() : super(PropertyInitial()){
    on<PropertyLoaded>((event, emit) async {

      emit(PropertyInProgress());

      try {
        final result = await _propertyRepository.fetchProperties(
          dni: event.dni,
          id: event.id,
          apiKey: event.apiKey,
        );

        emit( PropertySuccess(result: result));
      } on ResultException catch (e) {
          emit( PropertyFailure(result: e.result!));
      }
    });

    on<CurrentPropertySaved>((event, emit) async {

      try {
        PropertyModel property = (state as PropertySuccess).result.data;

        final negocios = property.negocios!.map((p) {
          if (p.producto!.idGci! == event.id) {
            if (!p.isCurrent!) {
              return p.copyWith(isCurrent: true);
            } else {
              return p;
            }
          } else {
            return p.copyWith(isCurrent: false);
          }
        }).toList();

        final data = property.copyWith(negocios: negocios);

        Result result =
        Result(data: data, message: 'isCurrent property changed!');

        emit( PropertySuccess(result: result));
      } catch (_) {
        emit( PropertyFailure(
            result: Result(message: 'Error in CurrentPropertySaved')));
      }

    });

    on<PropertyChanged>((event, emit) async {
      emit(PropertyInitial());
    });

  }

  @override
  PropertyState? fromJson(Map<String, dynamic> data) {
    try {
      final properties = propertyModelFromJson(json.decode(data['value']));

      return PropertySuccess(result: Result(data: properties));
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PropertyState state) {
    if (state is PropertySuccess) {
      return {'value': propertyModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';


import 'package:iclavis/models/property_model.dart';

part 'project_user_support_event.dart';
part 'project_user_support_state.dart';

class ProjectUserSupportBloc
    extends Bloc<ProjectUserSupportEvent, ProjectUserSupportState> {
  ProjectUserSupportBloc() : super(ProjectUserSupportInitial()) {
    on<ProjectUserSupportSelected>((event, emit) async {
      emit(ProjectUserSupportSelect(projectSelect: event.project!));
    });
  }
}

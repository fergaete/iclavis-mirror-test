import 'package:iclavis/models/project_model.dart';
import 'package:equatable/equatable.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:iclavis/services/project/project_repository.dart';
import 'package:iclavis/utils/http/result.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends HydratedBloc<ProjectEvent, ProjectState> {
  final ProjectRepository _projectRepository = ProjectRepository();
  ProjectBloc() : super(ProjectInitial()) {
    on<ProjectsLoaded>((event, emit) async {
      emit(ProjectInProgress());

      try {
        final result = await _projectRepository.fetchProjects(dni: event.dni);
        emit(ProjectSuccess(result: result));
      } on ResultException catch (e) {
        emit(ProjectFailure(result: e.result!));
      }
    });
    on<CurrentProjectSaved>((event, emit) async {
      try {
        List<ProjectModel> projects = (state as ProjectSuccess).result.data;

        if (projects
            .where((e) => e.proyecto!.gci!.id! == event.id)
            .isNotEmpty) {
          final data = projects.map((p) {
            if (p.proyecto!.gci!.id! == event.id) {
              if (!p.isCurrent) {
                return p.copyWith(isCurrent: true);
              } else {
                return p;
              }
            } else {
              return p.copyWith(isCurrent: false);
            }
          }).toList();

          Result result =
              Result(data: data, message: 'isCurrent property changed!');

          emit(ProjectSuccess(result: result));
        }
      } catch (_) {
        emit(ProjectFailure(
          result: Result(message: 'Error in CurrentProjectSaved'),
        ));
      }
    });
    on<ProjectChanged>((event, emit) async {
      emit(ProjectInitial());
    });
  }

  @override
  ProjectState? fromJson(Map<String, dynamic> data) {
    try {
      final projects = projectModelFromMap(data['value']);
      return ProjectSuccess(result: Result(data: projects));
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ProjectState state) {
    if (state is ProjectSuccess) {
      return {'value': projectModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}

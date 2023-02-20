part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class ProjectChanged extends ProjectEvent {}

class ProjectsLoaded extends ProjectEvent {
  final String dni;

  const ProjectsLoaded({required this.dni});

  @override
  List<Object> get props => [dni];

  @override
  String toString() => "ProjectsLoaded { DNI: $dni }";
}

class CurrentProjectSaved extends ProjectEvent {
  final int id;

  const CurrentProjectSaved({required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => "CurrentProjectSaved { Id: $id }";
}

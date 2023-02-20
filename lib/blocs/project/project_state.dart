part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectInProgress extends ProjectState {}

class ProjectSuccess extends ProjectState {
  final Result result;

  const ProjectSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => "ProjectSuccess { Result: $result }";
}

class ProjectFailure extends ProjectState {
  final Result result;

  const ProjectFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => "ProjectFailure { Result: $result }";
}

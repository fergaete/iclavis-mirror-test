part of 'project_user_support_bloc.dart';

@immutable
abstract class ProjectUserSupportEvent {}

class ProjectUserSupportSelected extends ProjectUserSupportEvent {

  final Negocio? project;
  ProjectUserSupportSelected({this.project});

  @override
  String toString() =>
      'NewRequestUserSupportSelectProjectEvent { project: ${project?.idGci} }';
}
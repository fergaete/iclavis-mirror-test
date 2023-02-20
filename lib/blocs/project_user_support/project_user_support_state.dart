part of 'project_user_support_bloc.dart';

@immutable
abstract class ProjectUserSupportState {}

class ProjectUserSupportInitial extends ProjectUserSupportState {}

class ProjectUserSupportSelect extends ProjectUserSupportState {
  final Negocio projectSelect;

  ProjectUserSupportSelect({required this.projectSelect});
}

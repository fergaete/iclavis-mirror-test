import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/models/project_model.dart';

import 'project_service.dart';

class ProjectRepository {
  final _projectService = ProjectService();
  final _handler = ExceptionHandler();

  Future<Result> fetchProjects({required String dni}) async {

    try {
      List<ProjectModel> projects = await _projectService.fetchProject(
        dni,
      );

      return Result(data: projects);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }
}

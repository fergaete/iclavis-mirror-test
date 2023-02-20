import 'package:collection/collection.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';

class PviValidator {
  int typeProject(ProjectModel project, Negocio negocio) {
    //gci
    if (project.inmobiliaria?.pvi == null && project.proyecto?.pvi?.id == null) {
      return 0;
    }
    //migrado sin fecha
    if (project.inmobiliaria?.pvi != null &&
        negocio.producto?.fechaEntrega == "0000-00-00") {
      return 1;
    }
    //gci y pvi
    if (project.inmobiliaria?.pvi != null &&
        negocio.producto?.fechaEntrega != "0000-00-00") {
      return 2;
    }
    return 0;
  }

  int typeProjectForPvi( ProjectModel project, List<Negocio?> negocio) {

    try{
      //gci
      if (project.inmobiliaria?.pvi == null && project.proyecto?.pvi?.id == null) {
        return 0;
      }
      //gci y pvi
      if ((project.inmobiliaria?.pvi != null && project.proyecto?.pvi?.id != null) &&
          (negocio.length > 1
              ? negocio
              .firstWhereOrNull((e) => e?.producto?.fechaEntrega != "0000-00-00") != null
              : negocio.first?.producto?.fechaEntrega != "0000-00-00")) {
        return 2;
      }
      //migrado sin fecha
      if ((project.inmobiliaria?.pvi != null ) &&
          (negocio.length > 1
              ? negocio.firstWhereOrNull((e) => e?.producto?.fechaEntrega == "0000-00-00") != null
              : negocio.first?.producto?.fechaEntrega == "0000-00-00")) {
        return 1;
      }
    }catch(e){
      return 0;
    }
    return 0;
  }
}

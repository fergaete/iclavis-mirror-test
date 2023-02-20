import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/blocs/post_sale_form/post_sale_form_bloc.dart';
import 'package:iclavis/blocs/post_sale_form_data/post_sale_form_data_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/project_user_support/project_user_support_bloc.dart';
import 'package:iclavis/models/post_sale_form_model.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/models/user_support_problem_model.dart';
import 'package:iclavis/models/user_support_type_warranty.dart';

import 'package:iclavis/widgets/widgets.dart';

import '../styles.dart';
import 'upload_file_postsale.dart';
import 'warranty_widget.dart';

final _styles = UserSupportViewsStyles();

class NewForm extends StatefulWidget {
  final int id;

  const NewForm(this.id, {super.key});

  @override
  State<NewForm> createState() => _NewFormState();
}

class _NewFormState extends State<NewForm> {
  late GlobalKey<FormBuilderState> formKey;

  PostSaleDataForm? postSaleDataForm;
  bool loading = false;
  bool loadingSelect = false;
  bool isValid = false;
  int? recinto, lugar, item, problema;
  TextEditingController desController = TextEditingController();
  UserSupportTypeWarranty? typeWarranty;
  ProjectModel? currentProject;
  Negocio? properties;
  List<FilePost> listImage = [];

  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final projects = (context.read<ProjectBloc>().state as ProjectSuccess)
        .result
        .data as List<ProjectModel>;

    properties = (context.read<ProjectUserSupportBloc>().state
            as ProjectUserSupportSelect)
        .projectSelect;

    currentProject = projects.where((e) => e.isCurrent).first;

    BlocProvider.of<PostSaleFormBloc>(context).add(PostSaleFormInitialLoaded(
        apiKey: currentProject!.inmobiliaria!.pvi!.first.apikey!,
        idTipoCasa: properties!.producto!.idTipoCasa!,
        idProblema: null,
        idRecinto: null,
        idItem: null,
        idLugar: null));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return BlocListener<PostSaleFormBloc, PostSaleFormState>(
      listener: (_, state) {
        if (state is PostSaleFormSelectInProgress) {
          setState(() {
            loadingSelect = true;
          });
        }

        if (state is PostSaleFormInitialSuccess) {
          setState(() {
            postSaleDataForm = state.result;
          });
        }
        if (state is PostSaleFormSelectSuccess) {
          setState(() {
            loadingSelect = false;
            postSaleDataForm = state.result;
          });
        }
        if (state is PostSaleFormTypeWarrantySuccess) {
          setState(() {
            loadingSelect = false;
            typeWarranty = state.result.data;
          });
        }
        if (state is PostSaleFormFileSuccess) {
          setState(() {
            listImage = state.listFile;
          });
        }
      },
      child: postSaleDataForm != null
          ? FormBuilder(
              key: formKey,
              onChanged: () {

                if (formKey.currentState?.fields['Recinto']?.value != null ||
                    formKey.currentState?.fields['Lugar']?.value != null ||
                    formKey.currentState?.fields['Item']?.value != null ||
                    formKey.currentState?.fields['Problema']?.value != null) {

                  if (formKey.currentState?.fields['Recinto']?.value != null) {
                    recinto = int.parse(formKey
                            .currentState?.fields['Recinto']?.value
                            .toString() ??
                        '0');
                    postSaleDataForm?.listLugar = null;
                    postSaleDataForm?.listItem = null;
                    postSaleDataForm?.listProblema = null;
                    lugar = null;
                    item = null;
                    problema = null;
                    formKey.currentState?.fields['Recinto']!.reset();

                  }
                  if (formKey.currentState?.fields['Lugar']?.value != null) {
                    lugar =
                        int.parse(formKey.currentState?.fields['Lugar']?.value);
                    postSaleDataForm?.listItem = null;
                    postSaleDataForm?.listProblema = null;
                    item = null;
                    problema = null;
                    formKey.currentState?.fields['Lugar']!.reset();
                  }

                  if (formKey.currentState?.fields['Item']?.value != null) {
                    item =
                        int.parse(formKey.currentState?.fields['Item']?.value);
                    postSaleDataForm?.listProblema = null;
                    problema = null;
                    formKey.currentState?.fields['Item']!.reset();
                  }

                  if (formKey.currentState?.fields['Problema']?.value != null ) {
                    problema = int.parse(
                        formKey.currentState?.fields['Problema']?.value);
                    formKey.currentState?.fields['Problema']!.reset();
                  }

                  BlocProvider.of<PostSaleFormBloc>(context).add(
                      PostSaleFormSelectChange(
                          apiKey:
                              currentProject!.inmobiliaria!.pvi!.first.apikey!,
                          idTipoCasa: properties!.producto!.idTipoCasa!,
                          idRecinto: recinto,
                          idItem: item,
                          idLugar: lugar,
                          idProblema: problema,
                          postSaleDataForm: postSaleDataForm));
                }

                if (formKey.currentState?.fields['Item']?.value != null ||
                    (item != null &&
                        formKey.currentState?.fields['Lugar']?.value != null)) {
                  BlocProvider.of<PostSaleFormBloc>(context).add(
                      PostSaleFormLoadwarranty(
                          apiKey:
                              currentProject!.inmobiliaria!.pvi!.first.apikey!,
                          idPropiedad: properties!.producto!.idPvi!,
                          idItem: item,
                          idLugar: lugar));
                } else if (item == null && problema == null) {
                  typeWarranty = null;
                }

                if (validForm()) {
                  setState(() => isValid = true);
                } else {
                  setState(() => isValid = false);
                }
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        i18n("form.Postventa_Titulo_Requerimiento"),
                        style: _styles.regularText(18.sp),
                      ),
                      IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () => openPostSaleDialog(context)),
                      Expanded(child: Container()),
                      if (widget.id != 0)
                        IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              BlocProvider.of<PostSaleFormDataBloc>(context)
                                  .add(PostSaleFormDataRemoveRequest(
                                      id: widget.id));
                            })
                    ],
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    height: 1,
                  ),
                  !loadingSelect
                      ? Column(
                          children: [
                            TextFieldPostSale(
                              "Recinto",
                              listItem: postSaleDataForm?.listRecinto,
                              formKey: formKey,
                              initData: recinto,
                            ),
                            TextFieldPostSale(
                              "Lugar",
                              listItem: postSaleDataForm?.listLugar,
                              formKey: formKey,
                              initData: lugar,
                            ),
                            TextFieldPostSale(
                              "Item",
                              listItem: postSaleDataForm?.listItem,
                              formKey: formKey,
                              initData: item,
                            ),
                            TextFieldPostSale(
                              "Problema",
                              listItem: postSaleDataForm?.listProblema,
                              formKey: formKey,
                              initData: problema,
                            ),
                            DescriptionField(
                              label: "Descripción",
                              formKey: formKey,
                              controller: desController,
                              onChange: (v){
                                if (validForm()) {
                                  setState(() => isValid = true);
                                } else {
                                  setState(() => isValid = false);
                                }
                              },
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 150.h,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                  SizedBox(
                    height: 15.h,
                  ),
                  WarrantyStatus(typeWarranty),
                  SizedBox(
                    height: 15.h,
                  ),
                  WarrantyType(typeWarranty),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Adjuntar:",
                        style: _styles.lightText(14.sp),
                      ),
                      Container()
                    ],
                  ),
                  UploadFilePostSale(id: widget.id),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 36.h,
                        width: 126.w,
                        margin: EdgeInsets.all(20.h),
                        child: FormButton(
                          label: i18n(
                              "form.Postventa_Boton_Aceptar_Requerimiento"),
                          isEnabled: isValid,
                          onPressed: () {
                            BlocProvider.of<PostSaleFormDataBloc>(context)
                                .add(PostSaleFormDataCloseRequest(
                              itemFormData: PostSaleFormModel(
                                  id: widget.id,
                                  estado: 1,
                                  idRecinto: recinto,
                                  nameReciento: postSaleDataForm?.listRecinto!
                                          .where(
                                              (e) => e.id == recinto.toString())
                                          .first
                                          .nombre ??
                                      '',
                                  idLugar: lugar,
                                  nameLugar: postSaleDataForm?.listLugar!
                                          .where(
                                              (e) => e.id == lugar.toString())
                                          .first
                                          .nombre ??
                                      '',
                                  idItem: item,
                                  nameItem: postSaleDataForm?.listItem!
                                          .where((e) => e.id == item.toString())
                                          .first
                                          .nombre ??
                                      '',
                                  idProblema: problema,
                                  nameProblema: postSaleDataForm?.listProblema!
                                          .where((e) =>
                                              e.id == problema.toString())
                                          .first
                                          .nombre ??
                                      '',
                                  descripcion: desController.text,
                                  warranty: typeWarranty,
                                  listFile: listImage),
                            ));
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ))
          : const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  bool validForm() {
    return (item != null &&
        lugar != null &&
        problema != null &&
        recinto != null &&
        desController.text.trim().isNotEmpty);
  }

  void openPostSaleDialog(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (BuildContext context) => PostSaleDialog(
        height: 350.h,
        title: FlutterI18n.translate(
            context, "form.Postventa_Modal_Informacion_Titulo"),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.maxFinite,
          height: 300.h,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                "Este es un formulario para ingresar solicitudes de postventa."
                " Si tiene más de un requerimiento, le recomendamos crear"
                " una solicitud que incluya todos los requerimientos que desee,"
                " para agendar una sola visita a su propiedad.\n\n"
                "Recuerde consultar el manual de propietario correspondiente"
                " a su proyecto antes de ingresar una solicitud.\n\n"
                " Verifique que las garantías aun siguen vigentes.",
                style: _styles.lightText(15.sp),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldPostSale extends StatelessWidget {
  final String label;
  final List<dynamic>? listItem;
  final GlobalKey<FormBuilderState> formKey;
  final int? initData;

  TextFieldPostSale(this.label,
      {super.key, @required this.listItem, required this.formKey, this.initData});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
        name: label,
        builder: (field) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: initData != null ? initData.toString() : null,
              items: listItem != null
                  ? listItem!
                      .map((i) => DropdownMenuItem(
                          value: i.id,
                          child: SizedBox(
                              width: 250.w,
                              child: Text(
                                "${i.nombre}",
                                maxLines: 1,
                              ))))
                      .toList()
                  : null,
              decoration: InputDecoration(
                  errorStyle: const TextStyle(fontSize: 18.0),
                  labelText: label,
                  labelStyle: const TextStyle(color: Color(0xff656565)),
                  contentPadding: const EdgeInsets.only(left: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.w),
                    borderSide: const BorderSide(
                      color: Color(0xff2f2f2f),
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.w),
                    borderSide: const BorderSide(
                      color: Color(0xff2f2f2f)
                    )),

              ),

              onChanged: (v) {
                field.didChange(v);
              },
            ),
          );
        });
  }
}

class DescriptionField extends StatelessWidget {
  final String? label;
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController controller;
  final ValueChanged<String>? onChange;
  const DescriptionField(
      {super.key, this.label, required this.formKey, required this.controller,this.onChange});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
        name: label ?? '',
        builder: (field) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: controller,
                maxLines: 4,
                minLines: 4,
                maxLength: 225,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    errorStyle: const TextStyle(fontSize: 18.0),
                    labelText: label,
                    labelStyle: const TextStyle(color: Color(0xff2f2f2f)),
                    contentPadding: const EdgeInsets.only(left: 10, top: 20),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.w),
                        borderSide: const BorderSide(
                          color: Color(0xff2f2f2f),
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.w),
                      borderSide: const BorderSide(
                        color: Color(0xff2f2f2f),
                      ),
                    )),
                onChanged:onChange,),
          );
        });
  }
}

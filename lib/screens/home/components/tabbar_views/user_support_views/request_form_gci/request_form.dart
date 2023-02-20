import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:iclavis/blocs/new_request_user_support/new_request_user_support_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/project_user_support/project_user_support_bloc.dart';
import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/models/user_support_category_model.dart';
import 'package:iclavis/widgets/action_button/widget.dart';

import '../styles.dart';

final _styles = UserSupportViewsStyles();

class RequestForm extends StatefulWidget {
  final bool? pvi;
  const RequestForm({Key? key, this.pvi}) : super(key: key);

  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm>
    with AutomaticKeepAliveClientMixin<RequestForm> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  TextEditingController commentsController = TextEditingController();

  late NewRequestUserSupportBloc newRequestUserSupportBloc;
  late UserModel user;
  late ProjectModel currentProject;
  List<UserSupportCategoryModel> categories = [];
  List<Categoria> categoriesSelected = [];
  List<Negocio> properties = [];

  bool isFormValid = false;
  bool categoriesDisable = true;
  bool categoriesReset = false;

  @override
  void didChangeDependencies() {
    user = (context.read<UserBloc>().state as UserSuccess).user;
    final projects = (context.read<ProjectBloc>().state as ProjectSuccess)
        .result
        .data as List<ProjectModel>;

    currentProject = projects.where((e) => e.isCurrent).first;

    newRequestUserSupportBloc = context.read<NewRequestUserSupportBloc>();

    final userSupportState = newRequestUserSupportBloc.state;
    final propertyState = context.read<PropertyBloc>().state;

    if (userSupportState is NewRequestUserSupportSuccess) {
      categories =
          (userSupportState.result.data as List<UserSupportCategoryModel>);

      categoriesSelected.addAll(categories.expand((e) => e.categorias!));
    }

    if (userSupportState is NewRequestUserSupportSendedSuccess) {
      commentsController.text = '';

      setState(() {
        isFormValid = false;
      });
    }

    if (propertyState is PropertySuccess) {
      properties = (propertyState.result.data as PropertyModel).negocios!;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    context.watch<NewRequestUserSupportBloc>();
    context.watch<PropertyBloc>();

    return FormBuilder(
      key: formKey,
      onChanged: () {
        if (formKey.currentState!.fields['requestType'] != null) {
          setState(() {
            categoriesReset = false;
            categoriesSelected = categories
                .firstWhere((e) => e.id == formKey.currentState!.fields['requestType']?.value)
                .categorias!;

            if (formKey.currentState!.fields['categoryId']?.value != null) {
              dynamic data = categoriesSelected.firstWhere(
                      (e) => e.id == formKey.currentState!.fields['categoryId']?.value,
              orElse: () => Categoria(
                glosa: 'SinCategoria'
              ));
              if (data.glosa == 'SinCategoria') {

                //formKey.currentState.fields['categoryId'].didChange(null);
                formKey.currentState!.fields['categoryId']?.reset();
                setState(() {
                  categoriesReset = true;
                });

              }
            }

            categoriesDisable = false;
          });
        }

        if (formKey.currentState!.validate()) {
          setState(() => isFormValid = true);
        } else {
          setState(() => isFormValid = false);
        }
      },
      child: Column(
        children: [
          RequestTypeButton(categories: categories),
          CategoryButton(
              categoriesSelected: categoriesSelected,
              disable: categoriesDisable,
              reset: categoriesReset),
          CommentsButton(commentsController: commentsController),
          SendButton(
              formKey: formKey,
              isFormValid: isFormValid,
              bloc: newRequestUserSupportBloc,
              dni: user.dni!,
              apiKey: widget.pvi!
                  ? currentProject.inmobiliaria!.pvi![0].apikey!
                  : currentProject.inmobiliaria!.gci!.apikey!,
              pvi: widget.pvi!)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class RequestTypeButton extends StatefulWidget {
  final List<UserSupportCategoryModel> categories;

  const RequestTypeButton({Key? key, required this.categories})
      : super(key: key);

  @override
  _RequestTypeButtonState createState() => _RequestTypeButtonState();
}

class _RequestTypeButtonState extends State<RequestTypeButton> {
  String? requestType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 296.w,
      height: 38.h,
      margin: EdgeInsets.only(top: 14.h),
      decoration: _styles.requestFormBorder(const Color(0xffE7E7E7)),
      child: FormBuilderField(
        name: 'requestType',
        builder: (field) {
          return DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isExpanded: true,
                hint: Text(
                  requestType ?? 'Tipo de solicitud',
                  overflow: TextOverflow.ellipsis,
                  style: _styles.lightText(14.sp),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Icon(Icons.expand_more, size: 15.w),
                ),
                items: List.generate(
                  widget.categories.length,
                  (i) => DropdownMenuItem(
                      value: widget.categories[i].id,
                      child: Text(widget.categories[i].glosa ?? '')),
                ),
                onChanged: (v) {
                  field.didChange(v);
                  setState(() {
                    requestType =
                        widget.categories.firstWhere((e) => e.id == v).glosa!;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryButton extends StatefulWidget {
  final List<Categoria> categoriesSelected;
  final bool disable;
  final bool reset;

  CategoryButton({
    Key? key,
    required this.categoriesSelected,
    this.disable = true,
    this.reset = false,
  }) : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  String? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 296.w,
      height: 38.h,
      margin: EdgeInsets.only(top: 14.h),
      decoration: _styles.requestFormBorder(const Color(0xffE7E7E7)),
      child: FormBuilderField(
        name: 'categoryId',
        validator:
            FormBuilderValidators.compose([FormBuilderValidators.required()]),
        builder: (field) {
          return DropdownButtonHideUnderline(
            child: ButtonTheme(
                alignedDropdown: true,
                child: IgnorePointer(
                  ignoring: widget.disable,
                  child: DropdownButton<int>(
                    isExpanded: true,
                    hint: Text(
                      widget.reset ? 'Categorias' : category ?? 'Categorias',
                      overflow: TextOverflow.ellipsis,
                      style: _styles.lightText(14.sp),
                    ),
                    icon: Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Icon(Icons.expand_more, size: 15.w),
                    ),
                    items: List.generate(
                      widget.categoriesSelected.length,
                      (i) => DropdownMenuItem(
                          value: widget.categoriesSelected[i].id,
                          child:
                              Text(widget.categoriesSelected[i].glosa ?? '')),
                    ),
                    onChanged: (v) {
                      field.didChange(v);
                      setState(() {
                        category = widget.categoriesSelected
                            .firstWhere((e) => e.id == v)
                            .glosa;
                      });
                    },
                  ),
                )),
          );
        },
      ),
    );
  }
}

class CommentsButton extends StatelessWidget {
  final TextEditingController commentsController;

  CommentsButton({
    Key? key,
    required this.commentsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 296.w,
      height: 110.h,
      margin: EdgeInsets.only(top: 14.h),
      decoration: _styles.requestFormBorder(const Color(0xffE7E7E7)),
      child: FormBuilderField(
        name: 'comments',
        validator:
        FormBuilderValidators.compose([FormBuilderValidators.required()]),
          builder: (field) {
            return TextFormField(
              controller: commentsController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: _styles.commentsDecoration('Comentarios'),
              onChanged: (v) => field.didChange(v),
            );
          },
        ),
    );
  }
}

class SendButton extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final bool isFormValid;
  final NewRequestUserSupportBloc bloc;
  final String dni;
  final String apiKey;
  final bool pvi;

  const SendButton({
    Key? key,
    required this.formKey,
    required this.isFormValid,
    required this.bloc,
    required this.dni,
    required this.apiKey,
    required this.pvi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      width: 286.w,
      margin: EdgeInsets.only(top: 20.h),
      child: ActionButton(
        label: 'Enviar solicitud',
        labelStyle: _styles.mediumText(
          18.sp,
          Colors.white,
        ),
        isEnabled: isFormValid,
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();

          formKey.currentState?.save();

          if (isFormValid && true) {
            FocusManager.instance.primaryFocus?.unfocus();

            final propertyState = context.read<ProjectUserSupportBloc>().state;

            if (pvi) {
              final idProducto = (propertyState as ProjectUserSupportSelect)
                  .projectSelect
                  .producto!
                  .idPvi!;
              formKey.currentState?.save();

              final requestBody = {
                'key': apiKey,
                'rutCliente': dni,
                'idProducto': idProducto,
                'idTipo': formKey.currentState?.value['requestType'],
                'medioIngreso': 'APP PROPIETARIOS',
                'idCategoria': formKey.currentState?.value['categoryId'],
                'descripcion': formKey.currentState?.value['comments'],
              };
              bloc.add(
                NewRequestUserSupportRequestPviSended(
                  apiKey: apiKey,
                  requestBody: requestBody,
                ),
              );
            } else {
              final idProducto = (propertyState as ProjectUserSupportSelect)
                  .projectSelect
                  .producto!
                  .idGci!;
              formKey.currentState?.save();
              final requestBody = {
                'rutCliente': dni,
                'idProducto': idProducto,
                'idCategoria': formKey.currentState?.value['categoryId'],
                'consulta': formKey.currentState?.value['comments'],
              };
              bloc.add(
                NewRequestUserSupportRequestSended(
                  apiKey: apiKey,
                  requestBody: requestBody,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';

import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/blocs/document/document_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/document_model.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:iclavis/widgets/widgets.dart';


final _styles = TextStylesShared();

class DocBody extends StatefulWidget {
  const DocBody({Key? key}) : super(key: key);

  @override
  _DocBodyState createState() => _DocBodyState();
}

class _DocBodyState extends State<DocBody> {
  Result? result;

  @override
  void didChangeDependencies() async {
    final documentBloc = context.read<DocumentBloc>();

    final userState = context.read<UserBloc>().state;
    final projectState = context.read<ProjectBloc>().state;

    if (userState is UserSuccess && projectState is ProjectSuccess) {
      final currentProject = (projectState.result.data as List<ProjectModel>)
          .firstWhere((e) => e.isCurrent);

      if (documentBloc.state is! DocumentSuccess) {
        documentBloc.add(
          DocumentLoaded(
            dni: userState.user.dni!,
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
            idProyecto: currentProject.proyecto!.gci!.id!,
          ),
        );
      }
      if (documentBloc.state is DocumentSuccess) {
        result = (documentBloc.state as DocumentSuccess).result;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return BlocConsumer<DocumentBloc, DocumentState>(
      buildWhen: (c, n) => n is! DocumentDownloadSuccess,
      listener: (_, state) async {
        if (state is DocumentDownloadInProgress) {
          showWaitAnimation(context);
        }
        if (state is DocumentDownloadSuccess) {
          removeWaitAnimation();
          final status = await OpenFilex.open(state.result.data);
          if (!status.message.contains('done')) {
            ExceptionOverlay(context: context, message: status.message);
          }
        } else if (state is DocumentFailure) {
          removeWaitAnimation();
          if (state.result.message!.contains('server')) {
            ModalOverlay(
              context: context,
              message: 'Parece que hay problemas con nuestro servidor.'
                  ' Aprovecha de despejar la mente e intenta más tarde.',
              title: '¡Ups!',
              buttonTitle: 'Entendido',
            );
          }
        }
        if (state is DocumentSuccess) {
          setState(() {
            result = state.result;
          });
        }
      },
      builder: (_, state) {
        if (result != null) {
          if (result!.data.length != 0) {
            return ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: result?.data.length,
              itemBuilder: (_, i) {
                List<DocumentModel> documents = result?.data;
                return DocCard(
                  categoryName: documents[i].categoryName ?? '',
                  documents: documents[i].documents,
                );
              },
            );
          } else {
            return Align(
              alignment: Alignment.topCenter,
              child: EmptyCard(
                text: i18n("archive.empty_documents"),
              ),
            );
          }
        } else if (state is DocumentFailure) {
          return Center(child: Text(state.result.message ?? ''));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class DocCard extends StatelessWidget {
  final String categoryName;
  final List<Document> documents;

  const DocCard({
    Key? key,
    required this.categoryName,
    required this.documents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.h,
      shadowColor: const Color(0xffdbdbdb),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.06.w),
      ),
      margin: EdgeInsets.fromLTRB(
        16.w,
        4.h,
        16.w,
        14.h,
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 93.h,
        ),
        child: ExpansionCard(
          title: categoryName,
          leading: Icon(
            CustomIcons.i_documento_cerrado,
            size: 58.w,
            color: Colors.black,
          ),
          icon: true,
          child: Column(
              children: List.generate(
            documents.length,
            (i) => ListTileTheme(
              contentPadding: EdgeInsets.fromLTRB(14.w, 0, 13.w, 5.h),
              child: ListTile(
                leading: Icon(
                  CustomIcons.i_reserva,
                  size: 28.w,
                ),
                title: Text(
                  documents[i].name ?? '',
                  style: _styles.lightText(14.sp, const Color(0xff121212)),
                ),
                trailing: GestureDetector(
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xffe0e0e0).withOpacity(.7),
                            offset: Offset(0, 5.h),
                            blurRadius: 6)
                      ],
                    ),
                    child: Icon(
                      CustomIcons.i_descargar,
                      size: 13.w,
                    ),
                  ),
                  onTap: () => context.read<DocumentBloc>().add(
                        DocumentDownloaded(
                          documentUrl: documents[i].url ?? '',
                          documentName: documents[i].name ?? '',
                        ),
                      ),
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}

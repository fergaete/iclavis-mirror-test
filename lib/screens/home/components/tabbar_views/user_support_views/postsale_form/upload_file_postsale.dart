

import 'dart:io';
import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/blocs/post_sale_form/post_sale_form_bloc.dart';
import 'package:iclavis/models/post_sale_form_model.dart';
import 'package:iclavis/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../styles.dart';

final _styles = UserSupportViewsStyles();

class UploadFilePostSale extends StatefulWidget {
  final int id;
  const UploadFilePostSale({super.key,  required this.id});

  @override
  _UploadFilePostSaleState createState() => _UploadFilePostSaleState();
}

class _UploadFilePostSaleState extends State<UploadFilePostSale> {
  List<FilePost> listFile = [];
  int idFile = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            height: listFile.length <= 3
                ? 100.w
                : ((listFile.length / 3) * 85.w) + 100.w,
            margin: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: BlocConsumer<PostSaleFormBloc, PostSaleFormState>(
                listener: (context, state) {
              if (state is PostSaleFormFileSuccess) {
                setState(() {
                  listFile = state.listFile;
                });
              }
            }, builder: (context, state) {
              return listFile.isEmpty
                  ? GestureDetector(
                      onTap: () => showModalBottom(context),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 30.sp,
                            ),
                            Text(
                              "Presione para cargar",
                              style: _styles.lightText(14.sp),
                            )
                          ],
                        ),
                      ))
                  : GridView.builder(
                      itemCount: listFile.length,
                      itemBuilder: (_, i) => itemFile(listFile[i]),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                    );
            })),
        if (listFile.isNotEmpty)
          Padding(
            padding: EdgeInsets.all(10.w),
            child: listFile.length >= 3
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "3 Archivos Max.",
                            style: _styles.lightText(14.sp),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => showModalBottom(context),
                        child: Row(
                          children: [
                            const Icon(Icons.add_circle_outline_sharp),
                            Text(
                              "Otro Archivo",
                              style: _styles.lightText(14.sp),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          )
      ],
    );
  }

  void showModalBottom(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camara'),
                  onTap: () {
                    _pickImage(0);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  leading: const Icon(Icons.add_photo_alternate),
                  title: const Text('Galeria'),
                  onTap: () {
                    _pickImage(1);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Archivo'),
                  onTap: () {
                    kIsWeb?_pickFileWeb():_pickFile();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  _pickImage(int type) async {
    XFile? pickedFile;
    if (type == 0) {
      pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
    }
    if (type == 1) {
      pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
    }

    if (pickedFile != null) {
      if (RegExp(r"(png|jpg|jpeg|gif|BMP)$")
          .stringMatch(pickedFile.path)!
          .isEmpty) {
        ExceptionOverlay(context: context, message: "Formato no permitido");
      } else {
        idFile++;
        if (!mounted) return;
        BlocProvider.of<PostSaleFormBloc>(context).add(PostSaleFormDataAddFile(
            file: FilePost(id: idFile, type: 0, file: File(pickedFile.path))));
      }
    }
  }

  _pickFile() async {
   final extFIle = ['pdf', 'jpg', 'jpeg', 'png', 'prf', 'doc', 'xls'];

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extFIle,
    );

    if (result != null) {
      double sizeInMb = result.files.single.size / (1024 * 1024);
      if (sizeInMb > 5) {
        ExceptionOverlay(context: context, message: "Max 5Mb");
      } else {
          if (RegExp(r"(png|jpg|jpeg|gif|BMP|pdf|doc|xls|prf)$")
              .stringMatch(result.files.single.path!)!
              .isEmpty) {
            ExceptionOverlay(context: context, message: "Formato no permitido");
          } else {
            idFile++;
            if (!mounted) return;
            BlocProvider.of<PostSaleFormBloc>(context).add(
                PostSaleFormDataAddFile(
                    file: FilePost(
                        id: idFile,
                        name: result.files.single.name,
                        type: 1,
                        file: File(result.files.single.path!))));
          }
      }
    }
  }

  _pickFileWeb() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;
      idFile++;
      if (!mounted) return;
      BlocProvider.of<PostSaleFormBloc>(context).add(PostSaleFormDataAddFile(
          file: FilePost(id: idFile, name:fileName,type: 1,
              file: File.fromRawPath(fileBytes!),
              fileWeb: fileBytes)));
    }
  }

  Widget itemFile(FilePost file) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Stack(
        alignment: const Alignment(1, -1),
        children: [
          file.type == 0
              ? Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      image: DecorationImage(
                          image: FileImage(file.file!), fit: BoxFit.cover)),
                )
              : Container(
                  width: 80.w,
                  height: 80.w,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Icon(Icons.file_copy), Text(file.name ?? '')],
                  ),
                ),
          GestureDetector(
            onTap: () {
              setState(() {
                BlocProvider.of<PostSaleFormBloc>(context)
                    .add(PostSaleFormDataRemoveFile(idFile: file.id!));
              });
            },
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

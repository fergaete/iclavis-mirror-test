import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclavis/blocs/post_sale_form_data/post_sale_form_data_bloc.dart';
import 'package:iclavis/models/post_sale_form_model.dart';
import 'package:iclavis/screens/home/components/tabbar_views/user_support_views/postsale_form/warranty_widget.dart';

import '../styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final _styles = UserSupportViewsStyles();

class ResumeCard extends StatelessWidget {
  final PostSaleFormModel itemFormData;
  ResumeCard({super.key, required this.itemFormData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Folio: ", style: _styles.regularText(16.sp)),
              Text("folio-${itemFormData.id}", style: _styles.lightText(15.sp)),
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          Text("Detalle: ", style: _styles.regularText(14.sp)),
          SizedBox(
              width: 300.w,
              child: Text(
                "${itemFormData.nameReciento ?? ''}/${itemFormData.nameLugar ?? ''} /${itemFormData.nameProblema ?? ''}  ",
                style: _styles.lightText(14.sp),
              )),
          SizedBox(
            height: 10.w,
          ),
          Text("${itemFormData.descripcion ?? ''} ",
              style: _styles.lightText(14.sp)),
          SizedBox(
            height: 10.w,
          ),
          Text("Garantia: ", style: _styles.regularText(14.sp)),
          StatusRequest(
              itemFormData.warranty?.nombre ?? "NO DEFINIDA", 1),
          SizedBox(
            height: 10.w,
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          Row(
            children: [
              //IconButton(icon: Icon(Icons.edit,color: Colors.black87,), onPressed: null),
              /*IconButton(
                  icon: Icon(
                    Icons.photo,
                    color: Colors.black87,
                  ),
                  onPressed: null),*/
              Expanded(child: Container()),
              IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    BlocProvider.of<PostSaleFormDataBloc>(context).add(
                        PostSaleFormDataRemoveRequest(id: itemFormData.id!));
                  })
            ],
          )
        ],
      ),
    );
  }
}

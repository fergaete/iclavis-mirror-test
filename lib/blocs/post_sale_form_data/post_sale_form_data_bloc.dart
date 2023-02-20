import 'package:bloc/bloc.dart';
import 'package:iclavis/models/post_sale_form_model.dart';
import 'package:meta/meta.dart';

part 'post_sale_form_data_event.dart';
part 'post_sale_form_data_state.dart';

class PostSaleFormDataBloc
    extends Bloc<PostSaleFormDataEvent, PostSaleFormDataState> {
  PostSaleFormDataBloc() : super(PostSaleFormDataInitial()) {
    on<PostSaleFormDataInit>((event, emit) async {
      List<PostSaleFormModel> listFormData = [];
      listFormData.add(PostSaleFormModel(id: 0, estado: 0));
      emit(PostSaleFormDataSuccess(listFormData: listFormData));
    });
    on<PostSaleFormDataAddRequest>((event, emit) async {
      emit(PostSaleFormDataInProgress());
      List<PostSaleFormModel> listFormData =
          (state as PostSaleFormDataSuccess).listFormData;
      listFormData
          .add(PostSaleFormModel(id: listFormData.last.id! + 1, estado: 0));
      emit(PostSaleFormDataSuccess(listFormData: listFormData));
    });
    on<PostSaleFormDataCloseRequest>((event, emit) async {


      List<PostSaleFormModel> listFormData =
          (state as PostSaleFormDataSuccess).listFormData;
      emit(PostSaleFormDataInProgress());
      int index =
          listFormData.indexWhere((item) => item.id == event.itemFormData.id);

      listFormData[index] = event.itemFormData;

      emit(PostSaleFormDataSuccess(listFormData: listFormData));
    });
    on<PostSaleFormDataRemoveRequest>((event, emit) async {



      List<PostSaleFormModel> listFormData =
          (state as PostSaleFormDataSuccess).listFormData;
      emit(PostSaleFormDataInProgress());
      if (listFormData.length > 1) {
        int index = listFormData.indexWhere((item) => item.id == event.id);
        listFormData.removeAt(index);
      } else {
        listFormData = [];
        listFormData.add(PostSaleFormModel(id: 0, estado: 0));
      }

      emit(PostSaleFormDataSuccess(listFormData: listFormData));
    });
  }
}

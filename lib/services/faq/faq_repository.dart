import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/models/faq_model.dart';

import 'faq_service.dart';

class FaqRepository {
  final _faqService = FaqService();
  final _handler = ExceptionHandler();

  Future<Result> fetchFaq({required String apiKey, required int idProyecto}) async {
    try {
      List<FaqModel> faqs = await _faqService.fetchFaq(
        apiKey,
        idProyecto,
      );

      return Result(data: faqs);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }
}

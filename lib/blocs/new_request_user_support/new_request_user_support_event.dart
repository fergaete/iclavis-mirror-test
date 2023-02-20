part of 'new_request_user_support_bloc.dart';

abstract class NewRequestUserSupportEvent extends Equatable {
  const NewRequestUserSupportEvent();

  @override
  List<Object> get props => [];
}

class NewRequestUserSupportCategoriesLoaded extends NewRequestUserSupportEvent {
  final String apiKey;

  const NewRequestUserSupportCategoriesLoaded({required this.apiKey});

  @override
  String toString() =>
      'NewRequestUserSupportCategoriesLoaded { ApiKey: $apiKey }';
}

class NewRequestUserSupportCategoriesLoadedPvi extends NewRequestUserSupportEvent {
  final String apiKey;

  const NewRequestUserSupportCategoriesLoadedPvi({required this.apiKey});

  @override
  String toString() =>
      'NewRequestUserSupportCategoriesLoaded { ApiKey: $apiKey }';
}

class NewRequestUserSupportRequestSended extends NewRequestUserSupportEvent {
  final String apiKey;
  final Map<String, dynamic> requestBody;

  const NewRequestUserSupportRequestSended({
    required this.apiKey,
    required this.requestBody,
  });

  @override
  String toString() =>
      'NewRequestUserSupportRequestSended { ApiKey: $apiKey, RequestBody: $requestBody}';
}

class NewRequestUserSupportRequestPviSended extends NewRequestUserSupportEvent {
  final String apiKey;
  final Map<String, dynamic> requestBody;

  const NewRequestUserSupportRequestPviSended({
    required this.apiKey,
    required this.requestBody,
  });

  @override
  String toString() =>
      'NewRequestUserSupportRequestSended { ApiKey: $apiKey, RequestBody: $requestBody}';
}
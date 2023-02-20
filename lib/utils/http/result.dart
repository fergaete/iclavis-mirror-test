class Result<T> {
  T? data;
  String? message;

  Result({this.data, this.message});

  Result.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        message = json['message'];

  Map<String, dynamic> toJson() => {'data': data, 'message': message};

  @override
  String toString() {
    return "Data: ${data.toString()}, Message: $message";
  }
}

class ResultException<E> implements Exception {
  Result? result;
  E? error;

  ResultException({data, message, this.error}) {
    this.result = Result(data: data, message: message);
  }

  @override
  String toString() {
    return "Error: ${error.toString()}, ${result.toString()}";
  }
}


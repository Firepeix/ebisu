
import 'package:ebisu/shared/http/request.dart';

abstract class Response {}

abstract class GenericResponse extends Response {
  String message;

  GenericResponse(this.message);
}

class Success extends GenericResponse {
  Success(super.message);
}

class TokenResponse extends DataResponse<String> {
  String get token => super.data;
  TokenResponse(super.message);
}

class ErrorResponse extends GenericResponse {
  String internalCode;
  int code;
  ErrorResponse(this.code, this.internalCode, super.message);
}

class DataResponse<T> extends Response {
  final T data;

  DataResponse(this.data);
}

typedef ListMapper<From, To> = To Function(From from);

class ListResponse<T> extends DataResponse<List<T>> {
  ListResponse(List<T> items) : super(items);

  ListResponse.raw(Map<String, dynamic> raw, ListMapper<Map<String, dynamic>, T> mapper)
      : this((raw["data"] as List).map((value) => mapper(value as Json)).toList());

      
  ListResponse<To> map<To>(ListMapper<T, To> mapper) {
    return ListResponse(data.map(mapper).toList());
  }
}

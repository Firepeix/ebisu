abstract class ResultError {
  final String? message;
  final String code;
  final Details? details;

  const ResultError(this.message, this.code, this.details);
}

class UnknownError extends ResultError {
  const UnknownError(details) : super("Ops! Ocorreu um erro. Tente Novamente mais tarde.", "FU1", details);
}

class Details {
  String? messageAddon;
  dynamic data;

  Details({this.messageAddon, this.data});
}

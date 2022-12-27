abstract class ResultError {
  final String? message;
  final String code;
  final Details? details;
  final Intrisincs? intrisincs = Intrisincs();

  ResultError(this.message, this.code, this.details);
}

class UnknownError extends ResultError {
  UnknownError(details) : super("Ops! Ocorreu um erro. Tente Novamente mais tarde.", "FU1", details);
}

class Details {
  String? messageAddon;
  String? messageOverride;
  dynamic data;

  Details({this.messageAddon, this.data, this.messageOverride});
}

class Intrisincs {
  String? messageOverride;

  Intrisincs({this.messageOverride});
}

class Installment {
  final int current;
  final int? total;

  Installment({required this.current, required this.total});

  bool isFinite() => total != null;
}
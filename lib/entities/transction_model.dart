class TransctionModel {
  final String id;
  final String transctionNumber;
  final String transctionAmount;
  final String transctionType;
  final String transctionStatus;
  final String transctionPaymentMethod;

  TransctionModel(
      {required this.id,
      required this.transctionNumber,
      required this.transctionAmount,
      required this.transctionType,
      required this.transctionStatus,
      required this.transctionPaymentMethod});

  factory TransctionModel.fromJson(Map<String, dynamic> map) {
    return TransctionModel(
        id: map["id"].toString(),
        transctionNumber: map["transaction_number"].toString(),
        transctionAmount: map["amount"].toString(),
        transctionType: map["type"],
        transctionStatus: map["status"],
        transctionPaymentMethod: map["payment_method"]);
  }
}

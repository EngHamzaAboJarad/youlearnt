class WalletAccountModel {
  final String id;
  final String email;
  final String type;
  final String accountNumber;
  final String? accountHodler;
  final String? routingNumber;
  final String? swiftBic;

  WalletAccountModel(
      {required this.id,
      required this.email,
      required this.type,
      required this.accountNumber,
      this.accountHodler,
      this.routingNumber,
      this.swiftBic});

  factory WalletAccountModel.fromJson(Map<String, dynamic> map) {
    return WalletAccountModel(
        id: map["id"].toString(),
        email: map["email"]??"",
        type: map["type"],
        accountNumber: map["account_number"]??"",
        accountHodler: map["account_holder"] ?? "",
        routingNumber: map["routing_number"] ?? "",
        swiftBic: map["swift_bic"] ?? "");
  }
}

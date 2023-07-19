import 'package:intl/intl.dart';
import 'package:you_learnt/entities/SubjectModel.dart';
import 'package:you_learnt/utils/functions.dart';

class WithdrawModel {
  WithdrawModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    lastEarningTotal = checkDouble(json['last_earning_total']);
    totalEarningCanDrow = checkDouble(json['total_earning_can_drow']);
    total = checkDouble(json['total']);
    balance = checkDouble(json['amount_can_drow']);
    statistic = json['statistic'] != null ? Statistic.fromJson(json['statistic']) : null;
    if (json['last_earning'] != null) {
      lastEarning = [];
      json['last_earning'].forEach((v) {
        lastEarning?.add(Data.fromJson(v));
      });
    }
  }

  List<Data>? data;
  double? lastEarningTotal;
  double? totalEarningCanDrow;
  double? total;
  double? balance;
  Statistic? statistic;
  List<Data>? lastEarning;
}

class Data {
  Data.fromJson(dynamic json) {
    id = json['id'];
    number = json['number'];
    userId = json['user_id'];
    discount = checkDouble(json['discount']);
    tax = checkDouble(json['tax']);
    total = checkDouble(json['total']);
    status = json['status'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    paymentTransactionId = json['payment_transaction_id'];
    paymentData = json['payment_data'] != null ? PaymentData.fromJson(json['payment_data']) : null;
    ip = json['ip'];
    userAgent = json['user_agent'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;

    if (json['student_packages'] != null) {
      studentPackages = [];
      json['student_packages'].forEach((v) {
        studentPackages?.add(SubjectModel.fromJson(v['teacher_subject']));
      });
    }
    try {
      date = DateFormat().add_yMMMd().add_Hm().format(DateTime.parse(updatedAt ?? ''));
    } catch (e) {}
  }

  int? id;
  String? number;
  int? userId;
  double? discount;
  double? tax;
  double? total;
  String? status;
  String? paymentStatus;
  String? paymentMethod;
  String? paymentTransactionId;
  PaymentData? paymentData;
  List<SubjectModel>? studentPackages;
  String? ip;
  String? userAgent;
  String? createdAt;
  String? updatedAt;
  String? date;
  Pivot? pivot;
}

class Pivot {
  Pivot.fromJson(dynamic json) {
    studentPackageId = json['student_package_id'];
    orderId = json['order_id'];
  }

  int? studentPackageId;
  int? orderId;
}

class PaymentData {
  PaymentData({
    this.statusCode,
    this.result,
    this.headers,
  });

  PaymentData.fromJson(dynamic json) {
    statusCode = json['statusCode'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    headers = json['headers'] != null ? Headers.fromJson(json['headers']) : null;
  }

  int? statusCode;
  Result? result;
  Headers? headers;
}

class Headers {
  Headers.fromJson(dynamic json) {
    contentType = json['Content-Type'];
    contentLength = json['Content-Length'];
    connection = json['Connection'];
    date = json['Date'];
    applicationId = json['Application_id'];
    cacheControl = json['Cache-Control'];
    callerAcctNum = json['Caller_acct_num'];
    paypalDebugId = json['Paypal-Debug-Id'];
    strictTransportSecurity = json['Strict-Transport-Security'];
  }

  String? contentType;
  String? contentLength;
  String? connection;
  String? date;
  String? applicationId;
  String? cacheControl;
  String? callerAcctNum;
  String? paypalDebugId;
  String? strictTransportSecurity;
}

class Result {
  Result.fromJson(dynamic json) {
    id = json['id'];
    intent = json['intent'];
    status = json['status'];
    paymentSource =
        json['payment_source'] != null ? PaymentSource.fromJson(json['payment_source']) : null;
    if (json['purchase_units'] != null) {
      purchaseUnits = [];
      json['purchase_units'].forEach((v) {
        purchaseUnits?.add(PurchaseUnits.fromJson(v));
      });
    }
    payer = json['payer'] != null ? Payer.fromJson(json['payer']) : null;
    createTime = json['create_time'];
    updateTime = json['update_time'];
    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links?.add(Links.fromJson(v));
      });
    }
  }

  String? id;
  String? intent;
  String? status;
  PaymentSource? paymentSource;
  List<PurchaseUnits>? purchaseUnits;
  Payer? payer;
  String? createTime;
  String? updateTime;
  List<Links>? links;
}

class Links {
  Links.fromJson(dynamic json) {
    href = json['href'];
    rel = json['rel'];
    method = json['method'];
  }

  String? href;
  String? rel;
  String? method;
}

class Payer {
  Payer.fromJson(dynamic json) {
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    emailAddress = json['email_address'];
    payerId = json['payer_id'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Name? name;
  String? emailAddress;
  String? payerId;
  Address? address;
}

class Address {
  Address.fromJson(dynamic json) {
    countryCode = json['country_code'];
  }

  String? countryCode;
}

class Name {
  Name.fromJson(dynamic json) {
    givenName = json['given_name'];
    surname = json['surname'];
  }

  String? givenName;
  String? surname;
}

class PurchaseUnits {
  PurchaseUnits.fromJson(dynamic json) {
    referenceId = json['reference_id'];
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    payee = json['payee'] != null ? Payee.fromJson(json['payee']) : null;
    shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    payments = json['payments'] != null ? Payments.fromJson(json['payments']) : null;
  }

  String? referenceId;
  Amount? amount;
  Payee? payee;
  Shipping? shipping;
  Payments? payments;
}

class Payments {
  Payments.fromJson(dynamic json) {
    if (json['captures'] != null) {
      captures = [];
      json['captures'].forEach((v) {
        captures?.add(Captures.fromJson(v));
      });
    }
  }

  List<Captures>? captures;
}

class Captures {
  Captures.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    finalCapture = json['final_capture'];
    sellerProtection = json['seller_protection'] != null
        ? SellerProtection.fromJson(json['seller_protection'])
        : null;
    sellerReceivableBreakdown = json['seller_receivable_breakdown'] != null
        ? SellerReceivableBreakdown.fromJson(json['seller_receivable_breakdown'])
        : null;
    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links?.add(Links.fromJson(v));
      });
    }
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  String? id;
  String? status;
  Amount? amount;
  bool? finalCapture;
  SellerProtection? sellerProtection;
  SellerReceivableBreakdown? sellerReceivableBreakdown;
  List<Links>? links;
  String? createTime;
  String? updateTime;
}

class SellerReceivableBreakdown {
  SellerReceivableBreakdown.fromJson(dynamic json) {
    grossAmount = json['gross_amount'] != null ? GrossAmount.fromJson(json['gross_amount']) : null;
    paypalFee = json['paypal_fee'] != null ? PaypalFee.fromJson(json['paypal_fee']) : null;
    netAmount = json['net_amount'] != null ? NetAmount.fromJson(json['net_amount']) : null;
  }

  GrossAmount? grossAmount;
  PaypalFee? paypalFee;
  NetAmount? netAmount;
}

class NetAmount {
  NetAmount.fromJson(dynamic json) {
    currencyCode = json['currency_code'];
    value = json['value'];
  }

  String? currencyCode;
  String? value;
}

class PaypalFee {
  PaypalFee.fromJson(dynamic json) {
    currencyCode = json['currency_code'];
    value = json['value'];
  }

  String? currencyCode;
  String? value;
}

class GrossAmount {
  GrossAmount.fromJson(dynamic json) {
    currencyCode = json['currency_code'];
    value = json['value'];
  }

  String? currencyCode;
  String? value;
}

class SellerProtection {
  SellerProtection.fromJson(dynamic json) {
    status = json['status'];
    disputeCategories =
        json['dispute_categories'] != null ? json['dispute_categories'].cast<String>() : [];
  }

  String? status;
  List<String>? disputeCategories;
}

class Amount {
  Amount.fromJson(dynamic json) {
    currencyCode = json['currency_code'];
    value = json['value'];
  }

  String? currencyCode;
  String? value;
}

class Shipping {
  Shipping.fromJson(dynamic json) {
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Name? name;
  Address? address;
}

class Payee {
  Payee.fromJson(dynamic json) {
    emailAddress = json['email_address'];
    merchantId = json['merchant_id'];
  }

  String? emailAddress;
  String? merchantId;
}

class PaymentSource {
  PaymentSource.fromJson(dynamic json) {
    paypal = json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null;
  }

  Paypal? paypal;
}

class Paypal {
  Paypal.fromJson(dynamic json) {
    emailAddress = json['email_address'];
    accountId = json['account_id'];
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  String? emailAddress;
  String? accountId;
  Name? name;
  Address? address;
}

class Statistic {
  Statistic.fromJson(dynamic json) {
    day0 = checkDouble(json['Day0']);
    day1 = checkDouble(json['Day1']);
    day2 = checkDouble(json['Day2']);
    day3 = checkDouble(json['Day3']);
    day4 = checkDouble(json['Day4']);
    day5 = checkDouble(json['Day5']);
    day6 = checkDouble(json['Day6']);
  }

  double? day0;
  double? day1;
  double? day2;
  double? day3;
  double? day4;
  double? day5;
  double? day6;
}

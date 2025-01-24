

import 'package:bluetooth_printing/network-mappers.dart';

class CreateOrderResponseModel extends BaseMappable {
  String? jsonrpc;
  int? id;
  int? statusCode;
  bool? isError;
  String? message;
  ResultData? result;

  CreateOrderResponseModel(
      {this.jsonrpc,
      this.id,
      this.result,
      this.statusCode,
      this.isError,
      this.message});

  CreateOrderResponseModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    statusCode = json['result']['status_code'];
    isError = json['result']['is_error'];
    message = json['result']['message'];
    result = json['result']['is_error'] == false
        ? ResultData.fromJson(json['result']['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'result': {
        'status_code': statusCode,
        'is_error': isError,
        'message': message,
        'result': isError == false ? result?.toJson() : result?.errorResult
      }
    };
  }

  @override
  Mappable fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    statusCode = json['result']['status_code'];
    isError = json['result']['is_error'];
    message = json['result']['message'];
    result = json['result']['is_error'] == false
        ? ResultData.fromJson(json['result']['result'])
        : null;
    return CreateOrderResponseModel(
        id: id,
        result: result,
        jsonrpc: jsonrpc,
        message: message,
        isError: isError,
        statusCode: statusCode);
  }
}

class ResultData {
  final int? orderId;
  final int? invoiceId;
  final String? invoicePdf;
  final int? errorResult; // to store error result if necessary
  InvoiceData? invoiceData;
  ResultData(
      {this.orderId,
      this.invoiceId,
      this.invoicePdf,
      this.errorResult,
      this.invoiceData});

  factory ResultData.fromJson(dynamic json) {
    if (json is int) {
      return ResultData(
          errorResult: json); // Error case where 'result' is an int
    } else {
      return ResultData(
          orderId: json['order_id'],
          invoiceId: json['invoice_id'],
          invoicePdf: json['invoice_pdf'],
          invoiceData: json['invoice_data'] != null
              ? new InvoiceData.fromJson(json['invoice_data'])
              : null);
    }
  }
  Object toJson() {
    if (errorResult != null) {
      // If it's an error, just return the error result
      return errorResult!;
    } else {
      return {
        'order_id': orderId,
        'invoice_id': invoiceId,
        'invoice_pdf': invoicePdf,
        'invoice_data': this.invoiceData!.toJson()
      };
    }
  }
}

class InvoiceData {
  Company? company;
  List<Items>? items;
  Totals? totals;

  InvoiceData({this.company, this.items, this.totals});

  InvoiceData.fromJson(Map<String, dynamic> json) {
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    totals =
        json['totals'] != null ? new Totals.fromJson(json['totals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.totals != null) {
      data['totals'] = this.totals!.toJson();
    }
    return data;
  }
}

class Company {
  String? name;
  String? vat;
  String? invoiceNumber;
  String? invoiceDate;
  String? customerName;
  String? customerVat;
  String? customerRegistrationNumber;
  String? salesman;
  String? qr;

  Company(
      {this.name,
      this.vat,
      this.invoiceNumber,
      this.invoiceDate,
      this.customerName,
      this.customerVat,
      this.customerRegistrationNumber,
      this.salesman,
      this.qr});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    vat = json['vat'];
    invoiceNumber = json['invoice_number'];
    invoiceDate = json['invoice_date'];
    customerName = json['customer_name'];
    customerVat = json['customer_vat'];
    customerRegistrationNumber = json['customer_registration_number'];
    salesman = json['salesman'];
    qr = json['qr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['vat'] = this.vat;
    data['invoice_number'] = this.invoiceNumber;
    data['invoice_date'] = this.invoiceDate;
    data['customer_name'] = this.customerName;
    data['customer_vat'] = this.customerVat;
    data['customer_registration_number'] = this.customerRegistrationNumber;
    data['salesman'] = this.salesman;
    data['qr'] = this.qr;
    return data;
  }
}

class Items {
  int? productId;
  String? productName;
  String? productCode;
  double? quantity;
  int? productUomId;
  String? productUomName;
  double? priceUnit;
  String? tax;
  double? discount;
  double? discountAmount;
  double? priceSubtotal;
  int? invoiceLineId;
  String? description;

  Items(
      {this.productId,
      this.productName,
      this.productCode,
      this.quantity,
      this.productUomId,
      this.productUomName,
      this.priceUnit,
      this.tax,
      this.discount,
      this.discountAmount,
      this.priceSubtotal,
      this.invoiceLineId,
      this.description});

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productCode = json['product_code'];
    quantity = json['quantity'];
    productUomId = json['product_uom_id'];
    productUomName = json['product_uom_name'];
    priceUnit = json['price_unit'];
    tax = json['tax'];
    discount = json['discount'];
    discountAmount = json['discount_amount'];
    priceSubtotal = json['price_subtotal'];
    invoiceLineId = json['invoice_line_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_code'] = this.productCode;
    data['quantity'] = this.quantity;
    data['product_uom_id'] = this.productUomId;
    data['product_uom_name'] = this.productUomName;
    data['price_unit'] = this.priceUnit;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['discount_amount'] = this.discountAmount;
    data['price_subtotal'] = this.priceSubtotal;
    data['invoice_line_id'] = this.invoiceLineId;
    data['description'] = this.description;
    return data;
  }
}

class Totals {
  double? quantity;
  double? price;
  double? vat;
  double? discount;
  double? grandTotal;

  Totals({this.quantity, this.price, this.vat, this.discount, this.grandTotal});

  Totals.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
    vat = json['vat'];
    discount = json['discount'];
    grandTotal = json['grand_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['vat'] = this.vat;
    data['discount'] = this.discount;
    data['grand_total'] = this.grandTotal;
    return data;
  }
}

import 'package:bluetooth_printing/create_order_response_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'dart:convert';
import 'dart:typed_data';

Widget logo() {
  return Image.asset(
    "assets/images/print_logo.jpeg",
    color: Colors.black,
    width: 400,
    height: 400,
  );
}

Widget compnayNameAndBasicData({InvoiceData? invoiceData}) {
  return Column(
    // mainAxisAlignment: MainAxisAlignment.center,
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          color: Colors.white,
          child: Image.asset(
            "assets/images/print_logo.jpeg",
            width: 320,
            height: 80,
          )),

      const SizedBox(height: 10),
      // Padding(
      //   padding: const EdgeInsets.symmetric(
      //     horizontal: 8.0,
      //   ),
      //   child: Text(invoiceData?.company?.name ?? "",
      //       style: const TextStyle(
      //           color: Colors.black,
      //           fontSize: 22,
      //           fontWeight: FontWeight.bold)),
      // ),

      Text("Vat ID:    ${invoiceData?.company?.vat ?? "N/A"} الضريبى ",
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),

      const Text("SA MADINA DC",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),

      const Text("Tax Invoice / فاتورة ضريبية",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),

      const Text("ORIGINAL / الاصل",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),

      Text("Invoice No:  ${invoiceData?.company?.invoiceNumber}",
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),

      Row(
        children: [
          const Text("Date/ تاريخ الفاتورة : ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text("${invoiceData?.company?.invoiceDate}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),

//////////////////////////
      Row(
        children: [
          const Text("Customer Name/اسم العميل : ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          Text("${invoiceData?.company?.customerName}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ],
      ),

      Row(
        children: [
          const Text("Cust. VAT#/ رقم العميل الضريبي : ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            width: 20,
          ),
          Text("${invoiceData?.company?.customerVat}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),

      Row(
        // mainAxisAlignment: MainAxisAlignment.,
        children: [
          const Text("Cust. CR/رقم السجل التجاري :   ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            width: 20,
          ),
          Text("${invoiceData?.company?.customerRegistrationNumber}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),

      Row(
        children: [
          const Text("Salesman/ المندوب :",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text("${invoiceData?.company?.salesman}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
      Row(
        children: List.generate(
            350 ~/ 10,
            (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      color: index % 2 == 0
                          ? Colors.transparent
                          : const Color.fromARGB(255, 71, 70, 70),
                      height: 2,
                    ),
                  ),
                )),
      ),

      SizedBox(
        // padding: EdgeInsets.symmetric(vertical: 6),
        // width: 420,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('Prd Code',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
            const Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Text('Product Description',
                  maxLines: 10,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ),
            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),

      SizedBox(
        // padding: EdgeInsets.symmetric(vertical: 6),
        // width: 420,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
                flex: 2,
                child: Text('(كود المنتج)',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
            const Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Text('(وصف المنتج)',
                  maxLines: 10,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),
      SizedBox(
        // padding: EdgeInsets.symmetric(vertical: 6),
        // width: 420,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 3, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('Qty',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
            const Flexible(
              flex: 2,
              // fit: FlexFit.tight,
              child: Text('Price',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('Disc',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('VAT',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('TOTAL',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),
      SizedBox(
        // padding: EdgeInsets.symmetric(vertical: 6),
        // width: 420,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 3, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('(كمية)',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
            const Flexible(
              flex: 2,
              // fit: FlexFit.tight,
              child: Text('(سعر)',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('(خصم)',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('(ضريبة)',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('(مجموع)',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),
      Row(
        children: List.generate(
            350 ~/ 10,
            (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      color: index % 2 == 0
                          ? Colors.transparent
                          : const Color.fromARGB(255, 71, 70, 70),
                      height: 2,
                    ),
                  ),
                )),
      ),
    ],
  );
}

Widget itemsData({InvoiceData? invoiceData}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      // Items Data
      if (invoiceData?.items != null)
        ...invoiceData!.items!.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 0.0,
            ),
            child: Column(
              children: [
                SizedBox(
                  // width: 420,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(item.productCode ?? "N/A",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                        flex: 6,
                        fit: FlexFit.tight,
                        child: Text(item.productName ?? "N/A",
                            maxLines: 10,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                      Flexible(flex: 1, child: Container()),
                    ],
                  ),
                ),
                SizedBox(
                  // padding: EdgeInsets.symmetric(vertical: 6),
                  // width: 420,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(flex: 3, child: Container()),
                      Flexible(
                        flex: 2,
                        child: Text(item.quantity?.toStringAsFixed(2) ?? "0",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                        flex: 2,
                        child: Text(item.priceUnit?.toStringAsFixed(2) ?? "0",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                        flex: 2,
                        child: Text(item.discount?.toStringAsFixed(2) ?? "0",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                        flex: 2,
                        child: Text(item.tax ?? "0",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                        flex: 2,
                        child: Text(
                            item.priceSubtotal?.toStringAsFixed(2) ?? "0",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                      Flexible(flex: 1, child: Container()),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
    ],
  );
}

Widget totalData({InvoiceData? invoiceData}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        children: List.generate(
            350 ~/ 10,
            (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      color: index % 2 == 0
                          ? Colors.transparent
                          : const Color.fromARGB(255, 71, 70, 70),
                      height: 2,
                    ),
                  ),
                )),
      ),
      SizedBox(
        // padding: EdgeInsets.symmetric(vertical: 6),
        // width: 420,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('Total',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),

            Flexible(
                flex: 2,
                child: Text("${invoiceData?.totals?.quantity}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),

            Flexible(
              flex: 2,
              // fit: FlexFit.tight,
              child: Text("${invoiceData?.totals?.price}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            Flexible(flex: 1, child: Container()),

            Flexible(
                flex: 2,
                child: Text("${invoiceData?.totals?.discount}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),

            Flexible(
                flex: 2,
                child: Text("${invoiceData?.totals?.vat}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),
      SizedBox(
        // padding: EdgeInsets.symmetric(vertical: 6),
        // width: 420,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flexible(flex: 1, child: Container()),
            const Flexible(
                flex: 2,
                child: Text('اجمالي',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            Flexible(flex: 4, child: Container()),

            Flexible(
                flex: 2,
                child: Text('${invoiceData?.totals?.grandTotal}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      Stack(
        alignment: Alignment.center,
        children: [
          // Row with text on both sides and the line
          Row(
            children: [
              // The dividing line
              Expanded(
                child: Row(
                  children: List.generate(
                    350 ~/ 10,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          color: index % 2 == 0
                              ? Colors.transparent
                              : const Color.fromARGB(255, 71, 70, 70),
                          height: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Centered Image
          // invoiceData?.company?.qr?.isEmpty == true
          //     ?
          Positioned(
              child: Image.asset(
            "assets/images/qr.png",
            width: 150,
            height: 150,
          )),
          // :
          Positioned(
            child: QRCodeImage(
              base64QRCode: invoiceData?.company?.qr ?? "",
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
      const Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text("Salesman Signature",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text("(توقيع البائع)",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            width: 80,
          ),
          Column(
            children: [
              Text("Customer Signature",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text("(توقيع العميل)",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
      const Text("Amounts are in SAR (ريال)",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      Text(
          "Printed on تاريخ ووقت الطباعة : ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      const Text("Payment of Delivery Note value is only",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      const Text("approved by a collection voucher",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      const Text("يعتبر بيان التسليم مسدد فقط بسند تحصيل رقم بيان التسليم",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      Row(
        children: List.generate(
            350 ~/ 10,
            (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      color: index % 2 == 0
                          ? Colors.transparent
                          : const Color.fromARGB(255, 71, 70, 70),
                      height: 2,
                    ),
                  ),
                )),
      ),
    ],
  );
}

Widget qrDataWidget({InvoiceData? invoiceData}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        color: Colors.white, // Background for the image
        width: 400,
        height: 400,
        child: QRCodeImage(
          base64QRCode: invoiceData?.company?.qr ?? "",
          width: 300,
          height: 150,
        ),
      ),
      Row(
        children: List.generate(
            350 ~/ 10,
            (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      color: index % 2 == 0
                          ? Colors.transparent
                          : const Color.fromARGB(255, 71, 70, 70),
                      height: 2,
                    ),
                  ),
                )),
      ),
    ],
  );
}

class QRCodeImage extends StatelessWidget {
  final String base64QRCode;
  final double? width;
  final double? height;

  const QRCodeImage({
    Key? key,
    required this.base64QRCode,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      // Check if the base64 string contains a prefix
      String base64Data = base64QRCode.contains(',')
          ? base64QRCode.split(',')[1]
          : base64QRCode;

      debugPrint('Base64 Data: $base64Data'); // Debug print

      // Decode the Base64 string into bytes
      Uint8List qrBytes = base64Decode(base64Data);

      debugPrint('QR Bytes: $qrBytes'); // Debug print

      // Display the QR Code as an image
      return Image.memory(
        qrBytes,
        width: width ?? 150, // Default width
        height: height ?? 150, // Default height
        fit: BoxFit.contain, // Ensure proper scaling
      );
    } catch (e) {
      // Return an error widget if decoding fails
      return Center(
        child: Text(
          'Invalid QR Code: ${e.toString()}',
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

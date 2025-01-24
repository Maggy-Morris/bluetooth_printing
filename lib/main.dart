import 'package:bluetooth_printing/command_tool.dart';
import 'package:bluetooth_printing/create_order_response_model.dart';
import 'package:bluetooth_printing/scan_bluetooth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      home: HomePage(
        pdfUrl: '',
        invoiceData: InvoiceData(),
      ),
    );
  }
}

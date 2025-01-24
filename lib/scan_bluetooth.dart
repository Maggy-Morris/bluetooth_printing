import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:bluetooth_printing/create_order_response_model.dart';
import 'package:bluetooth_printing/function_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class HomePage extends StatefulWidget {
   final String pdfUrl;
  final InvoiceData? invoiceData;
  const HomePage({super.key, required this.pdfUrl,  this.invoiceData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BluetoothDevice? _device;
  late StreamSubscription<bool> _isScanningSubscription;
  late StreamSubscription<BlueState> _blueStateSubscription;
  late StreamSubscription<ConnectState> _connectStateSubscription;
  late StreamSubscription<Uint8List> _receivedDataSubscription;
  late StreamSubscription<List<BluetoothDevice>> _scanResultsSubscription;
  List<BluetoothDevice> _scanResults = [];

  Future<void> _requestPermissions() async {
    // Check Bluetooth permissions
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothAdvertise.request();

    // Check location permissions
    await Permission.location.request();

    // Check Nearby Devices permissions
    await Permission.nearbyWifiDevices.request();

    if (await Permission.bluetooth.isDenied ||
        await Permission.location.isDenied ||
        await Permission.nearbyWifiDevices.isDenied) {
      setState(() {
        // _info = "Please grant all necessary permissions to use the app.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initBluetoothPrintPlusListen();

    _requestPermissions();
  }

  @override
  void dispose() {
    super.dispose();
    _isScanningSubscription.cancel();
    _blueStateSubscription.cancel();
    _connectStateSubscription.cancel();
    _receivedDataSubscription.cancel();
    _scanResultsSubscription.cancel();
    _scanResults.clear();
  }

  Future<void> initBluetoothPrintPlusListen() async {
    /// listen scanResults
    _scanResultsSubscription = BluetoothPrintPlus.scanResults.listen((event) {
      if (mounted) {
        setState(() {
          _scanResults = event;
        });
      }
    });

    /// listen isScanning
    _isScanningSubscription = BluetoothPrintPlus.isScanning.listen((event) {
      debugPrint('********** isScanning: $event **********');
      if (mounted) {
        setState(() {});
      }
    });

    /// listen blue state
    _blueStateSubscription = BluetoothPrintPlus.blueState.listen((event) {
      debugPrint('********** blueState change: $event **********');
      if (mounted) {
        setState(() {});
      }
    });

    /// listen connect state
    _connectStateSubscription = BluetoothPrintPlus.connectState.listen((event) {
      debugPrint('********** connectState change: $event **********');
      switch (event) {
        case ConnectState.connected:
          setState(() {
            if (_device == null) return;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FunctionPage(
                          device: _device!,
                          pdfUrl: widget.pdfUrl,
                          invoiceData: widget.invoiceData,
                        )));
          });
          break;
        case ConnectState.disconnected:
          setState(() {
            _device = null;
          });
          break;
      }
    });

    /// listen received data
    _receivedDataSubscription = BluetoothPrintPlus.receivedData.listen((data) {
      debugPrint('********** received data: $data **********');

      /// do something...
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BluetoothPrintPlus'),
        ),
        body: SafeArea(
            child: BluetoothPrintPlus.isBlueOn
                ? ListView(
                    children: _scanResults
                        .map((device) => Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(device.name),
                                      Text(
                                        device.address,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      const Divider(),
                                    ],
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      _device = device;
                                      await BluetoothPrintPlus.connect(device);
                                    },
                                    child: const Text("connect"),
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  )
                : buildBlueOffWidget()),
        floatingActionButton:
            BluetoothPrintPlus.isBlueOn ? buildScanButton(context) : null);
  }

  Widget buildBlueOffWidget() {
    return const Center(
        child: Text(
      "Bluetooth is turned off\nPlease turn on Bluetooth...",
      style: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 16, color: Colors.red),
      textAlign: TextAlign.center,
    ));
  }

  Widget buildScanButton(BuildContext context) {
    if (BluetoothPrintPlus.isScanningNow) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
          onPressed: onScanPressed,
          backgroundColor: Colors.green,
          child: const Text("SCAN"));
    }
  }

  Future onScanPressed() async {
    try {
      await BluetoothPrintPlus.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      debugPrint("onScanPressed error: $e");
    }
  }

  Future onStopPressed() async {
    try {
      BluetoothPrintPlus.stopScan();
    } catch (e) {
      debugPrint("onStopPressed error: $e");
    }
  }
}

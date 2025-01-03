import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:bluetooth_printing/command_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf_render/pdf_render.dart'; // For rendering PDF
import 'package:image/image.dart' as img; // For image processing
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // For downloading PDF

// ignore: constant_identifier_names
enum CmdType { Tsc, Cpcl, Esc }

class FunctionPage extends StatefulWidget {
  final BluetoothDevice device;

  const FunctionPage(this.device, {super.key});

  @override
  State<FunctionPage> createState() => _FunctionPageState();
}

class _FunctionPageState extends State<FunctionPage> {
  CmdType cmdType = CmdType.Tsc;
  bool _isLoading = false;
  final String pdfUrl = "https://www.orimi.com/pdf-test.pdf";
  @override
  void deactivate() {
    super.deactivate();
    _disconnect();
  }

  void _disconnect() async {
    await BluetoothPrintPlus.disconnect();
  }

  // Apply thresholding to the image
  void applyThreshold(img.Image image, int threshold) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final luminance =
            img.getLuminance(pixel); // Get luminance (grayscale value)
        final newLuminance =
            luminance < threshold ? 0 : 255; // Convert to black or white
        image.setPixel(
            x, y, img.ColorRgb8(newLuminance, newLuminance, newLuminance));
      }
    }
  }

//Function To Print PDF From URL
  Future<Uint8List?> _convertPdfToImage({required String pdfUrl}) async {
    // URL of the PDF file
    setState(() {
      _isLoading = true;
    });
    // Download the PDF file
    final response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode != 200) {
      throw Exception("Failed to download PDF: ${response.statusCode}");
    }

    // Load the PDF from the downloaded data
    final pdfData = response.bodyBytes;
    final pdfDoc = await PdfDocument.openData(pdfData);

    // Render the first page of the PDF as an image
    final page = await pdfDoc.getPage(1); // Render the first page
    final pageImage = await page.render(width: 500, height: 800);

    // Create an image from the rendered PDF page
    final image = img.Image.fromBytes(
      width: pageImage.width,
      height: pageImage.height,
      bytes: pageImage.pixels.buffer, // Use the pixel buffer
      order: img.ChannelOrder.bgra, // Specify the pixel format (ARGB)
    );

    // Resize the image to match the printer's printable width
    const int printerWidth = 576; // Example: 76mm printer (576 pixels)
    final double aspectRatio = image.height / image.width;
    final int newHeight = (printerWidth * aspectRatio).round();
    final resizedImage = img.copyResize(
      image,
      width: printerWidth,
      height: newHeight,
    );

    // Convert the image to grayscale
    final grayscaleImage = img.grayscale(resizedImage);

    // Increase contrast (optional, adjust the factor as needed)
    img.adjustColor(grayscaleImage, contrast: 1.5); // Increase contrast

    // Apply thresholding to the image
    const int threshold = 128; // Adjust this value as needed
    applyThreshold(grayscaleImage, threshold);

    // Convert the thresholded image to Uint8List (PNG format)
    final pngBytes = img.encodePng(grayscaleImage); // Use 'img.encodePng'
    setState(() {
      _isLoading = false;
    });
    return Uint8List.fromList(pngBytes);
  }

//Function To Print PDF From Assets

  // Future<Uint8List?> _convertPdfToImageFromAssets() async {
  //   // Load the PDF from assets
  //   // final pdfData = await rootBundle.load("assets/sales_receipt.pdf");

  //   final pdfData = await rootBundle.load("assets/inv3.pdf");
  //   final pdfDoc = await PdfDocument.openData(pdfData.buffer.asUint8List());

  //   // Render the first page of the PDF as an image
  //   final page = await pdfDoc.getPage(1); // Render the first page
  //   final pageImage = await page.render(width: 550, height: 800);

  //   // Create an image from the rendered PDF page
  //   final image = img.Image.fromBytes(
  //     width: pageImage.width,
  //     height: pageImage.height,
  //     bytes: pageImage.pixels.buffer, // Use the pixel buffer
  //     order: img.ChannelOrder.argb, // Specify the pixel format (ARGB)
  //   );

  //   // Resize the image to match the printer's printable width
  //   final int printerWidth = 576; // Example: 76mm printer (576 pixels)
  //   final double aspectRatio = image.height / image.width;
  //   final int newHeight = (printerWidth * aspectRatio).round();
  //   final resizedImage = img.copyResize(
  //     image,
  //     width: printerWidth,
  //     height: newHeight,
  //   );

  //   // Convert the resized image to Uint8List (PNG format)
  //   final pngBytes = img.encodePng(resizedImage); // Use 'img.encodePng'
  //   return Uint8List.fromList(pngBytes);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(
            //   width: double.infinity,
            //   height: 400,
            //   child: SfPdfViewer.asset(
            //     'assets/inv3.pdf',
            //     canShowPaginationDialog: true,
            //     onDocumentLoadFailed: (details) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //             content: Text("Failed to load PDF: ${details.error}")),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(
              width: double.infinity,
              height: 400,
              child: SfPdfViewer.network(
                pdfUrl,
                canShowPaginationDialog: true,
                onDocumentLoadFailed: (details) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Failed to load PDF: ${details.error}")),
                  );
                },
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          // Convert PDF to image
                          final Uint8List? image =
                              await _convertPdfToImage(pdfUrl: pdfUrl);
                          if (image != null) {
                            // Generate TSC command for the image
                            final cmd = await CommandTool.tscImageCmd(image);
                            // Send the command to the printer
                            await BluetoothPrintPlus.write(cmd);
                          }
                        },
                        child: Text("Print PDF"),
                      ),
                    ],
                  ),

            // Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         OutlinedButton(
            //           onPressed: () async {
            //             // Convert PDF to image
            //             final Uint8List? image =
            //                 await _convertPdfToImageFromAssets();
            //             if (image != null) {
            //               // Generate TSC command for the image
            //               final cmd = await CommandTool.tscImageCmd(image);
            //               // Send the command to the printer
            //               await BluetoothPrintPlus.write(cmd);
            //             }
            //           },
            //           child: Text("Print PDF"),
            //         ),
            //       ],
            //     ),
            // ),
          ],
        ),
      ),
    );
  }
}

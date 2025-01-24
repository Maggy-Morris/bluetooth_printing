import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:bluetooth_printing/command_tool.dart';
import 'package:bluetooth_printing/create_order_response_model.dart';
import 'package:bluetooth_printing/printer_widgets.dart';
import 'package:bluetooth_printing/receipt_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
// import 'package:pdf/widgets.dart' as pw;

import 'package:pdf_render/pdf_render.dart'; // For rendering PDF
import 'package:image/image.dart' as img; // For image processing
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // For downloading PDF

// ignore: constant_identifier_names
enum CmdType { Tsc, Cpcl, Esc }

class FunctionPage extends StatefulWidget {
  final BluetoothDevice device;
  final InvoiceData? invoiceData;
  final String pdfUrl;

  const FunctionPage(
      {required this.device,
      required this.pdfUrl,
      super.key,
      required this.invoiceData});

  @override
  State<FunctionPage> createState() => _FunctionPageState();
}

class _FunctionPageState extends State<FunctionPage> {
  CmdType cmdType = CmdType.Tsc;
  String? pdfUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    pdfUrl = widget.pdfUrl;
  }

  @override
  void deactivate() {
    super.deactivate();
    _disconnect();
  }

  void _disconnect() async {
    await BluetoothPrintPlus.disconnect();
  }

// // Apply thresholding to the image
//   void applyThreshold(img.Image image, int threshold) {
//     for (int y = 0; y < image.height; y++) {
//       for (int x = 0; x < image.width; x++) {
//         final pixel = image.getPixel(x, y);
//         final luminance =
//             img.getLuminance(pixel); // Get luminance (grayscale value)
//         final newLuminance =
//             luminance < threshold ? 0 : 255; // Convert to black or white
//         image.setPixel(
//             x, y, img.ColorRgb8(newLuminance, newLuminance, newLuminance));
//       }
//     }
//   }

  Future<List<Uint8List>> _convertPdfToImages({
    required String pdfUrl,
    int renderWidth = 500,
    int renderHeight = 800,
    double contrast = 1.0,
    double brightness = 1.0,
    double saturation = 1.0,
    bool convertToGrayscale = true,
    bool sharpenImage = true,
  }) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Download the PDF file
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode != 200) {
        throw Exception("Failed to download PDF: ${response.statusCode}");
      }

      // Load the PDF from the downloaded data
      final pdfData = response.bodyBytes;
      final pdfDoc = await PdfDocument.openData(pdfData);

      // List to hold the images of each page
      List<Uint8List> pageImages = [];

      // Iterate through all pages of the PDF
      for (int i = 1; i <= pdfDoc.pageCount; i++) {
        // Render the current page of the PDF as an image
        final page = await pdfDoc.getPage(i);
        final pageImage = await page.render(
          width: renderWidth,
          height: renderHeight,
        );

        // Create an image from the rendered PDF page
        var image = img.Image.fromBytes(
          width: pageImage.width,
          height: pageImage.height,
          bytes: pageImage.pixels.buffer,
          order: img.ChannelOrder.argb, // Use ARGB format
        );

        // Optional: Convert the image to grayscale
        if (convertToGrayscale) {
          img.grayscale(image);
        }

        // Optional: Adjust contrast, brightness, and saturation
        if (contrast != 1.0 || brightness != 1.0 || saturation != 1.0) {
          img.adjustColor(
            image,
            contrast: contrast,
            brightness: brightness,
            saturation: saturation,
          );
        }

        // Optional: Sharpen the image
        if (sharpenImage) {
          image = img.convolution(
            image,
            filter: [
              0,
              -1,
              0,
              -1,
              5,
              -1,
              0,
              -1,
              0,
            ],
            div: 1,
            offset: 0,
          );
        }

        // Convert the image to Uint8List (PNG format)
        final pngBytes = img.encodePng(image);
        pageImages.add(Uint8List.fromList(pngBytes));

        // Clean up page resources
        // await page.document.dispose();
      }

      return pageImages;
    } catch (e) {
      // Handle any errors that occur during the process
      throw Exception("Failed to convert PDF to images: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: SingleChildScrollView(
        child: (pdfUrl?.isEmpty == true &&
                widget.invoiceData?.company?.invoiceNumber?.isEmpty == true)
            ? const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        "No PDF Available",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  pdfUrl != ''
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 400,
                              child: SfPdfViewer.network(
                                pdfUrl ?? "",
                                canShowPaginationDialog: true,
                                onDocumentLoadFailed: (details) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Failed to load PDF: ${details.error}")),
                                  );
                                },
                              ),
                            ),
                            _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () async {
                                          // Convert PDF to a list of images (one image per page)
                                          final List<Uint8List> images =
                                              await _convertPdfToImages(
                                                  pdfUrl: pdfUrl ?? "");

                                          if (images.isNotEmpty) {
                                            for (final image in images) {
                                              // Generate TSC command for the current image
                                              final cmd = await CommandTool
                                                  .tscImageCmd2(image);

                                              // Send the command to the printer
                                              await BluetoothPrintPlus.write(
                                                  cmd);

                                              // Optional: Add a delay between pages to avoid overwhelming the printer
                                              await Future.delayed(const Duration(
                                                  seconds:
                                                      1)); // Adjust delay as needed
                                            }
                                          } else {
                                            debugPrint(
                                                "No images were generated from the PDF.");
                                          }
                                        },
                                        child: const Text("Print PDF"),
                                      ),
                                    ],
                                  ),
                          ],
                        )
                      : Center(
                          child: OutlinedButton(
                            onPressed: () async {
                              Uint8List? companyNameAs8List =
                                  await createImageFromWidget(
                                Container(
                                  color: Colors.white,
                                  child: compnayNameAndBasicData(
                                    invoiceData: widget.invoiceData,
                                  ),
                                ),
                                logicalSize: const Size(500, 500),
                                imageSize: const Size(600, 600),
                                cxt: context,
                              );

                              // Split items into chunks of 10
                              final items = widget.invoiceData?.items ?? [];
                              final chunkedItems = <List<Items>>[];
                              for (var i = 0; i < items.length; i += 6) {
                                chunkedItems.add(items.sublist(
                                  i,
                                  i + 6 > items.length ? items.length : i + 6,
                                ));
                              }

                              // Generate images for each chunk of items
                              List<Uint8List?> itemsDataAs8Lists = [];
                              for (var chunk in chunkedItems) {
                                Uint8List? chunkImage =
                                    await createImageFromWidget(
                                  Container(
                                    color: Colors.white,
                                    child: itemsData(
                                      invoiceData: InvoiceData(
                                          items:
                                              chunk), // Create a new InvoiceData
                                    ),
                                  ),
                                  logicalSize: const Size(500, 500),
                                  imageSize: const Size(600, 600),
                                  cxt: context,
                                );
                                itemsDataAs8Lists.add(chunkImage);
                              }

                              Uint8List? totalDataAs8List =
                                  await createImageFromWidget(
                                Container(
                                  color: Colors.white,
                                  child: totalData(
                                    invoiceData: widget.invoiceData,
                                  ),
                                ),
                                logicalSize: const Size(500, 500),
                                imageSize: const Size(600, 600),
                                cxt: context,
                              );

                              // Print images sequentially
                              if (companyNameAs8List != null &&
                                  totalDataAs8List != null &&
                                  itemsDataAs8Lists.isNotEmpty) {
                                // Print company name section
                                final companyCmd =
                                    await CommandTool.tscImageCmd(
                                        companyNameAs8List);
                                await BluetoothPrintPlus.write(companyCmd);

                                // Print each chunk of items
                                for (var itemsDataAs8List
                                    in itemsDataAs8Lists) {
                                  if (itemsDataAs8List != null) {
                                    final itemCmd =
                                        await CommandTool.tscImageCmd(
                                            itemsDataAs8List);
                                    await BluetoothPrintPlus.write(itemCmd);
                                  }
                                }

                                // Print total section
                                final totalCmd = await CommandTool.tscImageCmd(
                                    totalDataAs8List);
                                await BluetoothPrintPlus.write(totalCmd);
                              }
                            },
                            child: const Text("Print Invoice"),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}

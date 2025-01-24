import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart' hide Alignment;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as AnotherImage;

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// CommandTool
class CommandTool {
  static final tscCommand = TscCommand();
  static final cpclCommand = CpclCommand();
  static final escCommand = EscCommand();

  /// tscImageCmd

  /// tscImageCmd
  static Future<Uint8List?> tscImageCmd2(Uint8List image) async {
    await tscCommand.cleanCommand();
    await tscCommand.size(width: 70, height: 135);
    await tscCommand.cls(); // most after size
    await tscCommand.image(image: image, x: 50, y: 50);

    await tscCommand.print(1);
    final cmd = await tscCommand.getCommand();
    return cmd;
  }

  static Future<Uint8List?> tscImageCmd(Uint8List image) async {
    await tscCommand.cleanCommand();
    await tscCommand.size(width: 70, height: 85);
    await tscCommand.cls(); // most after size
    await tscCommand.image(image: image, x: 50, y: 50);

    await tscCommand.print(1);
    final cmd = await tscCommand.getCommand();
    return cmd;
  }

  // Future<Uint8List?> _renderTextAsImage(String arabicText) async {
  //   // Create a text widget with the Arabic text
  //   final recorder = PictureRecorder();
  //   final canvas = Canvas(recorder);
  //   final textPainter = TextPainter(
  //     text: TextSpan(
  //       text: arabicText,
  //       style: TextStyle(fontSize: 24, fontFamily: 'Arial'), // Adjust as needed
  //     ),
  //     textDirection: TextDirection.rtl, // Right-to-left for Arabic
  //   );

  //   textPainter.layout();
  //   textPainter.paint(canvas, Offset.zero);

  //   final picture = recorder.endRecording();
  //   final image = await picture.toImage(
  //     textPainter.width.toInt(),
  //     textPainter.height.toInt(),
  //   );

  //   final byteData = await image.toByteData(format: ImageByteFormat.png);
  //   return byteData?.buffer.asUint8List();
  // }

  // Future<Uint8List?> tscTest() async {
  //   await tscCommand.cleanCommand();
  //   await tscCommand.size(width: 10, height: 10);
  //   await tscCommand.cls(); // Clear the buffer

  //   // Generate an image from Arabic text
  //   final arabicImage = await _renderTextAsImage("مرحبا بالعالم");

  //   if (arabicImage != null) {
  //     await tscCommand.image(image: arabicImage, x: 50, y: 60);
  //     print("Image size: ${arabicImage.length}");
  //   } else {
  //     print("Failed to generate Arabic text image.");
  //   }

  //   await tscCommand.print(2);
  //   final cmd = await tscCommand.getCommand();
  //   return cmd;
  // }
  // static Future<Uint8List?> tscTest() async {
  //   await tscCommand.cleanCommand();
  //   await tscCommand.size(width: 10, height: 10);
  //   await tscCommand.cls(); // most after size

  //   await tscCommand.text(content: "Whyyyyyyy"); // most after size
  //   // await tscCommand.image(image: image, x: 50, y: 60);
  //   await tscCommand.print(2);
  //   final cmd = await tscCommand.getCommand();
  //   return cmd;
  // }
}

Future<Uint8List?> createImageFromWidget(Widget widget,
    {Duration? wait,
    Size? logicalSize,
    Size? imageSize,
    required BuildContext cxt}) async {
  // final cxt = appNavigatorKey.currentState!.context;

  // Create a repaint boundary to capture the image
  final repaintBoundary = RenderRepaintBoundary();

  // Calculate logicalSize and imageSize if not provided
  logicalSize ??= View.of(cxt).physicalSize / View.of(cxt).devicePixelRatio;
  imageSize ??= View.of(cxt).physicalSize;

  // Ensure logicalSize and imageSize have the same aspect ratio
  assert(logicalSize.aspectRatio == imageSize.aspectRatio,
      'logicalSize and imageSize must have the same aspect ratio');

  // Create the render tree for capturing the widget as an image
  final renderView = RenderView(
    view: View.of(cxt),
    child: RenderPositionedBox(
      alignment: Alignment.center,
      child: repaintBoundary,
    ),
    configuration: ViewConfiguration(
      logicalConstraints: BoxConstraints(
        maxWidth: logicalSize.width,
        maxHeight: logicalSize.height,
      ),
      // size: logicalSize,
      devicePixelRatio:
          View.of(cxt).devicePixelRatio, // Use actual device pixel ratio
    ),
  );

  final pipelineOwner = PipelineOwner();
  final buildOwner = BuildOwner(focusManager: FocusManager());

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  // Attach the widget's render object to the render tree
  final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: widget,
    ),
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);

  // Delay if specified
  if (wait != null) {
    await Future.delayed(wait);
  }

  // Build and finalize the render tree
  buildOwner
    ..buildScope(rootElement)
    ..finalizeTree();

  // Flush layout, compositing, and painting operations
  pipelineOwner
    ..flushLayout()
    ..flushCompositingBits()
    ..flushPaint();

  // Capture the image and convert it to byte data
  final image = await repaintBoundary.toImage(
    pixelRatio: imageSize.width / logicalSize.width,
  );
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  // Return the image data as Uint8List
  return byteData?.buffer.asUint8List();
}

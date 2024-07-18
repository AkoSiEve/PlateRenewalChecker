// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:camera_process/camera_process.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ltocheckerv2/views/scanner.view.dart';

class TextDetectorView extends StatefulWidget {
  const TextDetectorView({
    Key? key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;
  @override
  State<TextDetectorView> createState() => _TextDetectorViewState();
}

late String renewalDateMessage = "";
late String plateNumber = "";

class _TextDetectorViewState extends State<TextDetectorView> {
  TextDetector textDetector = CameraProcess.vision.textDetector();
  bool isBusy = false;
  CustomPaint? customPaint;

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final recognisedText = await textDetector.processImage(inputImage);

    // log("aaaaaaaaaaaaaaaaaaaaaa ${recognisedText.text}");
    // log("Future<void> processImage");

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      setState(() {});

      final painter = TextDetectorPainter(
          recognisedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
      _pnExpirationDateCalculation(plateNumber);
    } else {
      customPaint = null;

      // renewalDateMessage = "";
      // plateNumber = "";
    }

    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  //RENEWAL DATA MESSAGE

  _pnExpirationDateCalculation(String num) {
    List<String> months = [
      "October",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",

      // "November",
      // "December"
    ];
    try {
      final getLastDigit = num.substring(num.length - 1);
      final getSecondDigit = num.substring(num.length - 2, num.length - 1);
      switch (int.parse(getSecondDigit)) {
        case 1:
        case 2:
        case 3:
          // print("1st seven days of the months");

          setState(() {
            renewalDateMessage =
                "your vehicle is due for registration every 1st week of ${months[int.parse(getLastDigit)]}";
          });
          print(
              "your vehicle is due for registration every 1st week of ${months[int.parse(getLastDigit)]}");
          break;
        case 4:
        case 5:
        case 6:
          // print("2nd seven days of the months");
          setState(() {
            renewalDateMessage =
                "your vehicle is due for registration every 2nd week of ${months[int.parse(getLastDigit)]}";
          });
          print(
              "your vehicle is due for registration every 2nd week of ${months[int.parse(getLastDigit)]}");
          break;
        case 7:
        case 8:
          // print("3rd seven days of the months");
          setState(() {
            renewalDateMessage =
                "your vehicle is due for registration every 3rd week of ${months[int.parse(getLastDigit)]}";
          });
          print(
              "your vehicle is due for registration every 3rd week of ${months[int.parse(getLastDigit)]}");
          break;
        case 9:
        case 0:
          // print("4th seven days of the months");
          setState(() {
            renewalDateMessage =
                "your vehicle is due for registration every 4th week of ${months[int.parse(getLastDigit)]}";
          });
          print(
              "your vehicle is due for registration every 4th week of ${months[int.parse(getLastDigit)]}");
          break;
        default:
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return ScannerView(
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      camera: widget.camera,
    );
  }
}

////PAINTING THE BOUNDING BOX
///
class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(
      this.recognisedText, this.absoluteImageSize, this.rotation);
  final RecognisedText recognisedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;
    final Paint background = Paint()..color = Color(0x99000000);
    for (TextBlock textBlock in recognisedText.blocks) {
      for (TextLine line in textBlock.lines) {
        if ((line.text.length > 2) && (line.text.length <= 8)) {
          try {
            final getCharacter = line.text.replaceAll(RegExp("[^A-Za-z]"), "");
            final getNumber = line.text.replaceAll(RegExp(r"\D"), "");
            final getLastDigit = getNumber.substring(getNumber.length - 1);
            final getSecondDigit =
                getNumber.substring(getNumber.length - 2, getNumber.length - 1);
            if (getNumber.length >= 3 &&
                getNumber.length <= 4 &&
                getCharacter.length >= 3 &&
                getCharacter.length <= 4) {
              log("asdasd ${line.text}");

              plateNumber = line.text;

              ////////////////////
              final ParagraphBuilder builder = ParagraphBuilder(
                ParagraphStyle(
                    textAlign: TextAlign.left,
                    fontSize: 16,
                    textDirection: TextDirection.ltr),
              );
              builder.pushStyle(ui.TextStyle(
                  color: Colors.lightGreenAccent, background: background));
              builder.addText('${line.text}');
              builder.pop();
              final left =
                  translateX(line.rect.left, rotation, size, absoluteImageSize);
              final top =
                  translateY(line.rect.top, rotation, size, absoluteImageSize);
              final right = translateX(
                  line.rect.right, rotation, size, absoluteImageSize);
              final bottom = translateY(
                  line.rect.bottom, rotation, size, absoluteImageSize);
              canvas.drawRect(
                Rect.fromLTRB(left, top, right, bottom),
                paint,
              );
              canvas.drawParagraph(
                builder.build()
                  ..layout(ParagraphConstraints(
                    width: right - left,
                  )),
                Offset(left, top),
              );
////////////////
            }
          } catch (e) {}
        }
      }
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return oldDelegate.recognisedText != recognisedText;
  }
}

double translateX(
    double x, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
      return x *
          size.width /
          (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.Rotation_270deg:
      return size.width -
          x *
              size.width /
              (Platform.isIOS
                  ? absoluteImageSize.width
                  : absoluteImageSize.height);
    default:
      return x * size.width / absoluteImageSize.width;
  }
}

double translateY(
    double y, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
    case InputImageRotation.Rotation_270deg:
      return y *
          size.height /
          (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return y * size.height / absoluteImageSize.height;
  }
}

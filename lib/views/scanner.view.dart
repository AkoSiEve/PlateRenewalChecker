// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_process/camera_process.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ltocheckerv2/utils/global.colors.dart';
import 'package:ltocheckerv2/views/text.detect.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({
    Key? key,
    required this.camera,
    this.customPaint,
    required this.onImage,
  }) : super(key: key);
  final CameraDescription camera;
  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late CameraController _cameraController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startStreamImage();
  }

  _startStreamImage() {
    _cameraController = CameraController(widget.camera, ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController?.startImageStream(_processCameraImage);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  _processCameraImage(CameraImage image) {
    // check this class google_mlkit_commons/lib/src/input_image.dart

    // InputImageRotationMethods -> InputImageFormatValue
    // NV21 -> nv21
    // Rotation_0deg -> rotation0deg
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());
    final camera = widget.camera;

    final imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;
    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;
    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();
    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    widget.onImage(inputImage);
/**=================================================================== */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //IMAGE BACKGROUND
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg_crossroads.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: null,
            ),
            //LIGHBLUE BACJGROUND //
            Container(
              // color: GlobalColors.colorBlue.withOpacity(0.75),
              color: Color.fromRGBO(0, 54, 175, .75),
              width: double.infinity,
              margin: EdgeInsets.only(left: 15, right: 15),
              // height: double.infinity,
              height: 1065,
              child: null,
            ),
            //NAV
            Container(
              alignment: Alignment.centerLeft,
              color: GlobalColors.colorBlue,
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 70,
              child: Image.asset(
                "assets/lto_logo.png",
                scale: 7,
              ),
            ),
            Container(
              child: !_cameraController.value.isInitialized
                  ? Text("")
                  : Stack(
                      // alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 120, left: 50, right: 50),
                              width: MediaQuery.of(context).size.width / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                ),
                                child: AspectRatio(
                                  // aspectRatio: 9 / 16,
                                  aspectRatio:
                                      1 / _cameraController.value.aspectRatio,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CameraPreview(_cameraController),
                                      if (widget.customPaint != null)
                                        widget.customPaint!,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(top: 20, left: 40, right: 40),
                              width: double.infinity,
                              height: 50,
                              child: InkWell(
                                onTap: () {
                                  // _takePIcture();
                                  setState(() {
                                    renewalDateMessage = "";
                                    plateNumber = "";
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: GlobalColors.colorRed,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "Clear",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                            renewalDateMessage == ""
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(
                                        top: 20, left: 40, right: 40),
                                    width: double.infinity,
                                    // height: 200,
                                    // color: Colors.red,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        // color: GlobalColors.colorRed,
                                        color:
                                            const Color.fromARGB(255, 1, 110, 5)
                                                .withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Your Plate Number is : ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                Text(
                                                  "${plateNumber}",
                                                  style: TextStyle(
                                                      color:
                                                          GlobalColors.colorRed,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "${renewalDateMessage}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}


//https://medium.com/@kadircelikogluu/position-detection-with-google-ml-kit-7984615b5c85
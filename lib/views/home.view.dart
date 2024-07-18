// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ltocheckerv2/utils/global.colors.dart';
import 'package:ltocheckerv2/views/scanner.view.dart';
import 'package:ltocheckerv2/views/text.detect.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              //IMAGE BACKGROUND
              Container(
                height: 1115,
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
                // color: Colors.red,
                // width: double.infinity,
                height: 1065,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 150),
                      alignment: Alignment.center,
                      // color: Colors.red,
                      child: Column(
                        children: [
                          Text(
                            "Land Transportation",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "Management System",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    // LOGO CENTER
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      // color: Colors.green,
                      child: Image.asset(
                        "assets/lto_logo.png",
                        scale: 1.8,
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          Text(
                            "LTMS",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 70,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Plate Expiration Checker",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                        left: 40,
                        right: 40,
                      ),
                      child: Text(
                        "A front line government agency showcasing fast and efficient public service for a progressive land transport sector",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: InkWell(
                        onTap: () {
                          print("object");
                          // Get.to(() => ScannerView());
                          // Get.to(() => ScannerView(camera: widget.camera));
                          Get.to(() => TextDetectorView(camera: widget.camera));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: GlobalColors.colorRed,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Scan",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // color: Colors.black,
                      // padding: EdgeInsets.only(top: 100),
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.only(right: 20, bottom: 20),
                      height: 150,
                      width: double.infinity,
                      child: Image.asset("assets/lto_mid_logo_white_small.png",
                          scale: 3),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                bottom: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    height: 37,
                    // alignment: Alignment.topCenter,
                    width: double.infinity,
                    color: GlobalColors.colorBlue,
                    padding: EdgeInsets.only(right: 40, left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                child: Image.asset(
                                  "assets/cardboard-box_8820429.png",
                                  scale: 9,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                " Release 2.5.4",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_2_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              Text(
                                "589,077,354 page visits",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

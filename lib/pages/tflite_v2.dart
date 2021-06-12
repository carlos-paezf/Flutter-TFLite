import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TfliteHome(),
      theme: ThemeData.dark(),
    );
  }
}

class TfliteHome extends StatefulWidget {
  @override
  _TfliteHomeState createState() => _TfliteHomeState();
}

class _TfliteHomeState extends State<TfliteHome> {
  String _model = ssd;
  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  List _recognitions;

  @override
  void initState() {
    super.initState();
    _busy = true;
    loadModel().then((val) => setState(() => _busy = false));
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
          model: "assets/new_models/yolov2_tiny.tflite",
          labels: "assets/new_models/yolov2_tiny.txt",
        );
      } else {
        res = await Tflite.loadModel(
          model: "assets/new_models/ssd_mobilenet.tflite",
          labels: "assets/new_models/ssd_mobilenet.txt",
        );
      }
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  selectFromImagePicker() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image == null) return;
    _image = File(image.path);
    setState(() {
      _busy = true;
    });
    predictImage(_image);
  }

  predictImage(File image) async {
    if (image == null) return;
    if (_model == yolo) await yolov2Tiny(image);
    else await ssdMobileNet(image);
    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));
    setState(() {
      _image = image;
      _busy = false;
    });
  }

  yolov2Tiny(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);
    setState(() => _recognitions = recognitions);
  }

  ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);
    setState(() => _recognitions = recognitions);
  }
  
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;

    Color color = Colors.purple;

    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = color,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(
      Positioned(
        top: 0,
        left: 0.0,
        width: size.width,
        child: _image == null
            ? Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Seleccione una imagen para analizar',
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      backgroundColor: Colors.purpleAccent[700],
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent[700]),
                    ),
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                height: 400,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Image.file(_image),
                  ],
                ),
              ),
      ),
    );

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(
        Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.purpleAccent[700],
            valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.blueAccent[700],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: stackChildren,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.image,
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.black87,
        splashColor: Colors.blueAccent[700],
        tooltip: "Pick Image from gallery",
        onPressed: selectFromImagePicker,
      ),
    );
  }
}

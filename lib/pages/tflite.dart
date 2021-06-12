import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class TFLiteModel extends StatefulWidget {
  TFLiteModel({Key key}) : super(key: key);
  @override
  _TFLiteModelState createState() => _TFLiteModelState();
}

class _TFLiteModelState extends State<TFLiteModel> {
  bool _isLoading;
  File _image;
  List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadModel().then((value) => setState(() => _isLoading = true));
  }

  chooseImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null)
        _image = File(image.path);
      else
        _isLoading = true;
    });
    classifyImage(_image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        imageMean: 0.0,
        imageStd: 255.0,
        threshold: 0.5,
        asynch: true);
    setState(() {
      _isLoading = false;
      _output = output;
    });
  }

  loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/model/saved_model.tflite",
      labels: "assets/model/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
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
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 50, bottom: 50),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          _output == null
                              ? Text('')
                              : Column(
                                  children: [
                                    Text('La imagen se ha clasificado como:',
                                        style: TextStyle(fontSize: 17.5)),
                                    SizedBox(height: 7.5),
                                    Text('${_output[0]['label'].toUpperCase()}',
                                        style: TextStyle(fontSize: 40)),
                                    SizedBox(height: 15),
                                  ],
                                ),
                          _image == null
                              ? Container()
                              : SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                    width: double.infinity,
                                    height: 400,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [Image.file(_image)],
                                    ),
                                  ),
                                ),
                          SizedBox(height: 20),
                          _output == null
                              ? Text('')
                              : Column(
                                  children: [
                                    Text("Tengo una precisión de:",
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(height: 10),
                                    Text(
                                      "${(_output[0]['confidence'] * 100).toStringAsFixed(2)}%",
                                      style: TextStyle(fontSize: 40),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: chooseImage,
        tooltip: 'Pick Image',
        backgroundColor: Colors.black87,
        splashColor: Colors.blueAccent[700],
        child: Icon(
          Icons.image_search,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }
}

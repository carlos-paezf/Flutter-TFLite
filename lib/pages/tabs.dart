import 'package:flutter/material.dart';

import 'package:flutter_tflite/pages/presentacion.dart';
import 'package:flutter_tflite/pages/tflite.dart';
import 'package:flutter_tflite/pages/tflite_v2.dart';


class MyTabs extends StatefulWidget {
  MyTabs({Key key}) : super(key: key);

  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TFLite en Flutter'),
        backgroundColor: Colors.black54,
        bottom: new TabBar(
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.info_outline)),
            new Tab(icon: new Icon(Icons.photo_album_outlined)),
            new Tab(icon: new Icon(Icons.image_search)),
          ],
          controller: controller,
        ),
      ),
      body: new TabBarView(
        children: <Widget>[
          new Presentacion(),
          new MyApp(),
          new TFLiteModel(),
        ],
        controller: controller,
      ),
    );
  }
}

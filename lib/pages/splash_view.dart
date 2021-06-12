import 'package:flutter/material.dart';
import 'package:flutter_tflite/pages/tabs.dart';


class SplashView extends StatefulWidget {
  SplashView({Key key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

//! En caso de querer hacerlo sin el boton
/*
  @override
  void initState() { 
    super.initState();
    Future.delayed(
      Duration(
        seconds: 5,
      ),
      () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyTabs()))
    );  
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/icon/icon.png", 
                    width: MediaQuery.of(context).size.width/2,
                    height: 200,
                  ),
                ),
                Padding(padding: EdgeInsets.all(25)),

                Text('TFLite & Flutter', style: TextStyle(fontSize: 40),),
                Padding(padding: EdgeInsets.all(25)),

                FloatingActionButton(
                  backgroundColor: Colors.grey[900],
                  child: Icon(
                    Icons.arrow_right,
                    color: Colors.deepPurpleAccent,
                    size: 50,
                  ),
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyTabs())
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
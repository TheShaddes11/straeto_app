import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

int tala = 59;
String remaining;
bool snun = true;


Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  final secondCamera = cameras.last;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: secondCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MIÐINN MINN', style: TextStyle(color: Colors.red[900], fontSize: 23, fontWeight: FontWeight.bold)),

        backgroundColor: Colors.yellow[600],
        automaticallyImplyLeading: true,

          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                iconSize: 40,
                icon: Stack(children: <Widget>[
                  Icon(Icons.lens, color: Colors.red[900],),
                  Container(
                    padding: EdgeInsets.fromLTRB(7, 7, 20, 0),
                    child: Icon(Icons.menu, color: Colors.yellow[600], size: 25,),
                  ),
                ],),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),

          actions: <Widget>[
            IconButton(
              iconSize: 40,
              icon: Stack(children: <Widget>[
                Icon(Icons.lens, color: Colors.red[900]),
                Container(
                  padding: EdgeInsets.fromLTRB(9, 8, 10, 0),
                  child: Icon(Icons.send, color: Colors.yellow[600], size: 24,),
                )
              ],),
              onPressed: () {
                tala = 50;
                remaining = "50";
                print("button press");
                setState(() {
                  snun = !snun;
                });
              },
            )
          ],
      ),


      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

          Align(alignment: Alignment.topCenter,
          child: Container(
            height: 6,
            color: Colors.green[600],
          ),),

         Stack(
           children: <Widget>[
             Align(alignment: Alignment.topCenter,
               child: Container(
                 height: 6,
                 color: Colors.grey[200],
               ),),

             Align(alignment: Alignment.topLeft,
             child: AnimatedContainer(
               height: 6,
               width: snun ? 420 : 0,
               color: snun ? Colors.green[600] : Colors.green[800],
               duration: Duration(hours: 1),
             ),)
           ],
         ),
         /*
         Align(alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.green[900],
            height: 250,
            child: Column(children: <Widget>[
              Align(alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(left: 25, bottom: 3, top: 30),
                child: Row(children: <Widget>[

                  Text("01 ", style: TextStyle(fontSize: 65, fontFamily: "NunitoSans"),),

                  Column(children: <Widget>[
                    Icon(Icons.lens, color: Colors.yellow[600], size: 15,),
                    Icon(Icons.lens, color: Colors.green[900], size: 10,),
                    Icon(Icons.lens, color: Colors.yellow[600], size: 15,),
                  ],),

                  Text(" 14 ", style: TextStyle(fontSize: 65, fontFamily: "NunitoSans"),),

                  Column(children: <Widget>[
                    Icon(Icons.lens, color: Colors.yellow[600], size: 15,),
                    Icon(Icons.lens, color: Colors.green[900], size: 10,),
                    Icon(Icons.lens, color: Colors.yellow[600], size: 15,),

                  ],),

                  CountdownFormatted(
                      duration: Duration(seconds: tala),
                      onFinish: () {print("búið");},
                      builder: (BuildContext context, String remaining) {
                        return Text(" "+remaining, style: TextStyle(fontSize: 65, fontFamily: "NunitoSans"));
                      }
                  ),

                ],),
              ),),
              Icon(Icons.lens, color: Colors.green[900], size: 25,),

              Align(alignment: Alignment.bottomCenter,
              child:
              Center(child: Text("KLST.             MÍN.             SEK. ", style: TextStyle(letterSpacing: 1) ,) ,)
                ,)
            ],),
          ),
         ),
*/
         Align(alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.green[900],
            height: 250,
            child: Column(children: <Widget>[
              Align(alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 5, top: 30),
                child: Stack(children: <Widget>[
                  SlideCountdownClock(
                    duration: Duration(hours: 1, minutes: 12, seconds: 1),
                    slideDirection: SlideDirection.Up,
                    separator: " ",
                    textStyle: TextStyle(fontSize: 75, fontFamily: "NunitoSans"),
                    onDone: () {print("clock finsihed");},
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 96, top: 29),
                    child: Column(children: <Widget>[
                      Icon(Icons.lens, color: Colors.yellow[600], size: 15,),
                      Icon(Icons.lens, color: Colors.green[900], size: 10,),
                      Icon(Icons.lens, color: Colors.yellow[600], size: 15,),
                    ],),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 213, top: 29),
                    child: Column(children: <Widget>[
                      Icon(Icons.lens, color: Colors.yellow[600], size: 15,),
                      Icon(Icons.lens, color: Colors.green[900], size: 10,),
                      Icon(Icons.lens, color: Colors.yellow[600], size: 15,),
                    ],),
                  ),

                  AnimatedContainer(
                    child: Text("Hello"),
                    padding: EdgeInsets.only(left: 100, top: 30),
                    duration: Duration(seconds: 10),
                    height: snun ? 10 : 50,
                    width: snun ? 10 : 50,
                  ),

                ],)
              ),),

              Align(alignment: Alignment.bottomCenter,
              child:
              Center(child: Text("KLST.             MÍN.             SEK. ", style: TextStyle(letterSpacing: 1, fontSize: 15) ,) ,)
                ,)
            ],),
          ),
         ),

          Align(alignment: Alignment.bottomCenter,
            child: Container(
              height: 65,
              color: Colors.green[600],
              child: Align(alignment: Alignment.centerRight, child: Row(children: <Widget>[
                Stack(children: <Widget>[
                  Icon(Icons.lens, color: Colors.white, size: 50,),
                  Container(margin: EdgeInsets.only(left: 15, top: 5), child: Text("1", style: TextStyle(color: Colors.green[700], fontSize: 30, fontFamily: "NunitoSans"),),)
                ],),
                Text("ALMENNT FARGJALD", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, ),)
              ],),),
            ),
          ),


          Align(alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(bottom: 250),
              height: 50,
              width: 200,
              color: Colors.green[600],
              child: Align(
                alignment: Alignment.center,
                child: Text("ALMENNUR MIÐI", style: TextStyle(color: Colors.yellow[600], fontSize: 20, fontWeight: FontWeight.bold), ),
              )
          )),

// DeafultTextStyle er málið :: https://www.youtube.com/watch?v=fL2xleovE8A
          Center(
            child: AnimatedContainer(
              margin: EdgeInsets.only(bottom:320),
              width: snun ? 190 : 250,
              height: snun ? 200 : 260,
              color: Colors.yellow[600].withOpacity(0.8),
              alignment: Alignment.center,
              duration: Duration(hours: 2),
              curve: SineCurve(),
              child: AnimatedDefaultTextStyle(
                style: snun ?
                TextStyle(
                    fontSize: 140
                ) : TextStyle(
                    fontSize: 180
                ),
                duration: Duration(hours: 2),
                curve: SineCurve(),
                child: Text("S", style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.bold ,fontFamily: "Viga"),),
              )
            ),
          ),

/*
          Center(
            child: Stack(children: <Widget>[
              AnimatedContainer(
                margin: EdgeInsets.only(bottom:320),
                width: snun ? 180 : 250,
                height: snun ? 180 : 250,
                color: Colors.yellow[600].withOpacity(0.8),
                alignment: Alignment.center,
                duration: Duration(seconds: 60),
                curve: SineCurve(),
              ),

              AnimatedDefaultTextStyle(
                style: snun ?
                TextStyle(
                  fontSize: 140
                ) : TextStyle(
                  fontSize: 200
                ),
                duration: Duration(seconds: 60),
                curve: SineCurve(),
                child: Text(" S", style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.bold ,fontFamily: "Viga"),),
              )

            ],),
          )
*/

        ],
      )


    );
  }
}

class SineCurve extends Curve {
  final double count;

  SineCurve({this.count = 2200});

  @override
  double transformInternal(double t) {
    var val = sin(count * 2 * pi * t) * 0.5 + 0.5;
    return val;
  }
}

class NewCurve extends Curve {
  final double count;

  NewCurve({this.count = 60});

  @override
  double transformInternal(double t) {
    var val = sin(count * 2 * pi * t) * 0.5 + 0.5;
    return val;
  }
}
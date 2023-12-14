import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as IO;
import 'package:android_intent/android_intent.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo SDK',
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('PivoteSDK Flutter'),
            ),
            body: FlutterPage()));
  }
}

class FlutterPage extends StatefulWidget {
  @override
  FlutterComponent createState() => new FlutterComponent();
}

class FlutterComponent extends State<FlutterPage> {
  static const String _channel = 'test_activity';
  static const platform = const MethodChannel(_channel);
  String _dataFromFlutter = "Valores";

  @override
  void initState() {
    super.initState();
  }

  _getDocsFromiOS() async {
    String data;
    try {
      final String result = await platform
          .invokeMethod('getInfoDocs'); //sending data from flutter here
      data = result;
    } on PlatformException catch (e) {
      data = "Android is not responding please check the code";
    }
    print(data);
    setState(() {
      _dataFromFlutter = data;
    });
  }

  _getDataFromiOS() async {
    String data;
    try {
      final String result = await platform
          .invokeMethod('getInfoData'); //sending data from flutter here
      data = result;
    } on PlatformException catch (e) {
      data = "Android is not responding please check the code";
    }
    print(data);
    setState(() {
      _dataFromFlutter = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, rowNumber) {
          return new Container(
            padding: EdgeInsets.all(16.0),
            child: new Column(
              children: <Widget>[
                new Text(
                  'Flutter Component',
                  style: TextStyle(fontSize: 20.0, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                new SizedBox(
                  height: 16.0,
                ),
                new MaterialButton(
                    child: const Text('Open WebView'),
                    elevation: 5.0,
                    height: 48.0,
                    minWidth: 250.0,
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      print("button pressed");
                      _getNewActivity();
                    }),
                new SizedBox(
                  height: 16.0,
                ),
                new MaterialButton(
                    child: const Text('Get Documents'),
                    elevation: 5.0,
                    height: 48.0,
                    minWidth: 250.0,
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      print("button pressed");
                      if (IO.Platform.isAndroid) {
                        getDataFromAndroidDocuments();
                      } else {
                        _getDocsFromiOS();
                      }
                    }),
                new SizedBox(
                  height: 16.0,
                ),
                new MaterialButton(
                    child: const Text('Get Data'),
                    elevation: 5.0,
                    height: 48.0,
                    minWidth: 250.0,
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      print("button pressed");
                      if (IO.Platform.isAndroid) {
                        getDataFromAndroidSteps();
                      } else {
                        _getDataFromiOS();
                      }
                    }),
                Text(
                  _dataFromFlutter,
                ),
              ],
            ),
          );
        });
  }

  _getNewActivity() async {
    String data;
    try {
      final String result = await platform.invokeMethod('startNewActivity');
      data = result;
    } on PlatformException catch (e) {
      data = "Android is not responding please check the code";
    }
    print(data);
    setState(() {
      _dataFromFlutter = data;
    });
    if (IO.Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.RUN',
        package: 'com.example.flutter_app_dicio',
        componentName: 'com.example.flutter_app_dicio.MainActivity',
        arguments: {
          'route':
          '/Users/MichelHuerta/AndroidStudioProjects/flutter_app_dicio/lib/main.dart'
        },
      );
      await intent.launch();
    }
  }

  getDataFromAndroidSteps() async {
    String data;
    try {
      final String result = await platform
          .invokeMethod('getInfoSteps'); //sending data from flutter here
      data = result;
    } on PlatformException catch (e) {
      data = "Android is not responding please check the code";
    }
    setState(() {
      _dataFromFlutter = data;
    });
  }

  getDataFromAndroidDocuments() async {
    String data;
    try {
      final String result = await platform
          .invokeMethod('getInfoDocuments'); //sending data from flutter here
      data = result;
    } on PlatformException catch (e) {
      data = "Android is not responding please check the code";
    }
    setState(() {
      _dataFromFlutter = data;
    });
  }
}

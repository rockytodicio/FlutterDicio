
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as IO;
import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';


void main() => runApp(new MyApp());

enum Enviroment {Dev, QA, Demo, Prod}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PivoteSDK Flutter',
        home: Scaffold(
            appBar: AppBar(
              title: Text('PivoteSDK Flutter'),
            ),
            body: FlutterPage()
        )
    );
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
  Enviroment selectedEnvironment = Enviroment.Prod;
  String _APIKey = "CNVFKn77DYyZS5Du6LebjNA8IQNs2DHY";
  String _url = "https://app.proddicio.net/";
  TextEditingController apiKey = TextEditingController(text: "CNVFKn77DYyZS5Du6LebjNA8IQNs2DHY");
  TextEditingController urlEnviroment = TextEditingController(text: "https://app.proddicio.net/");


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
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Selecciona un ambiente',
                  style: TextStyle(fontSize: 20.0, color: Colors.blue),
                  textAlign: TextAlign.center
                ),

                CupertinoNavigationBar(

                    middle: CupertinoSlidingSegmentedControl<Enviroment>(
                      backgroundColor: CupertinoColors.systemGrey2,
                      thumbColor: CupertinoColors.activeBlue,

                      groupValue: selectedEnvironment,
                      onValueChanged: (Enviroment? value) {

                        if(value != null){
                          setState(() {
                            selectedEnvironment = value;

                          });
                        }

                      },
                      children: const <Enviroment, Widget>{
                        Enviroment.Demo: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Demo',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                        Enviroment.Dev: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Dev',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                        Enviroment.Prod: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Prod',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                        Enviroment.QA: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'QA',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                      },
                    )
                ),

                TextField(

                  onChanged: (apikey){
                    _APIKey = apikey;


                  },
                    controller: apiKey,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Agrega el APIKey',
                    hintText: 'CNVFKn77DYyZS5Du6LebjNA8IQNs2DHY',
                  )
                ),

                TextField(
                  onChanged: (urldicio){
                    _url = urldicio;
                  },
                    controller: urlEnviroment,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Agrega el URL',
                        hintText: 'https://app.proddicio.net/',

                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16)
                ),
                MaterialButton(
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
                SizedBox(
                  height: 16.0,
                ),
                MaterialButton(
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
                SizedBox(
                  height: 16.0,
                ),
                MaterialButton(
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
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16)
                ),
                Text(
                  _dataFromFlutter,
                )
              ],
            ),


          );

        });
  }
  _getNewActivity() async {
    String data;
    try {
      final String result = await platform.invokeMethod('startNewActivity',{
        'selectedEnvironment': selectedEnvironment.toString(),
        'APIKey': _APIKey,
        'url': _url,
      });
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

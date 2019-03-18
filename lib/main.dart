import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_sample/bridge.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String response = "";
  bool responseStream = false;

  StreamSubscription<bool> internetConnectivityStream;

  @override
  void initState() {
    super.initState();
    getMessageFromNative();

    listenToNativeStream();
  }

  @override
  void dispose() {
    internetConnectivityStream?.cancel();
    super.dispose();
  }

  void listenToNativeStream() {
    internetConnectivityStream = NativeBridge.listenToNativeEventChannel().listen(
        (string) {
          setState(() {
            this.responseStream = string;
          });
        }
    );
  }

  void changeInternetConnectivity() {
    NativeBridge.changeInternetConnectivity();
  }

  void getMessageFromNative() async {
    String responseFromNative = await NativeBridge.sayHiToNative();
    setState(() {
      this.response = responseFromNative;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'The message from native message channel is',
              textAlign: TextAlign.center,
            ),
            Text(
              '$response',
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.center,
            ),
            Text(
              'Is the internet connected?',
              textAlign: TextAlign.center,
            ),
            Text(
              responseStream ? "YES" : "NOPE",
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: changeInternetConnectivity
      ),
    );
  }
}

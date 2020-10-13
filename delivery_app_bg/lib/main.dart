import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/app_retain_widget.dart';
import 'package:flutter_background/background_main.dart';
import 'package:flutter_background/counter_service.dart';
import 'package:flutter_background/locationMqttPublisher.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:uuid/uuid.dart';
import 'constants.dart' as Constants;

void main() {
  runApp(MyApp());

  var channel = const MethodChannel('com.example/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());

  CounterService().startCounting();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Demo',
      home: AppRetainWidget(
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocationMqttPublisher locationPublisher;
  Geolocator.Position position;

  @override
  void initState() {
    super.initState();
    var uuid = Uuid();
    this.locationPublisher = new LocationMqttPublisher(
        Constants.serverUri, Constants.port, uuid.v1(), Constants.topicName,
        (Geolocator.Position position) {
      setState(() {
        print(position);
        this.position = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Background Demo'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            ValueListenableBuilder(
              valueListenable: CounterService().count,
              builder: (context, count, child) {
                return Text('Counting: $count');
              },
            ),
            Text(
              'This is your location:',
            ),
            Text(
              position == null
                  ? "No data"
                  : position.latitude.toString() +
                      ', ' +
                      position.longitude.toString(),
            ),
          ])),
    );
  }
}

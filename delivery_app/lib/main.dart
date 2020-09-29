import 'package:delivery_app/locationMqttPublisher.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'constants.dart' as Constants;
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geotracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Geotracker'),
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
  LocationMqttPublisher locationPublisher;
  Geolocator.Position position;

  void init() {}

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var uuid = Uuid();
    locationPublisher = new LocationMqttPublisher(
        Constants.serverUri, Constants.port, uuid.v1(), Constants.topicName,
        (Geolocator.Position position) {
      setState(() {
        this.position = position;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'locationWrapper.dart';
import 'mqttClientWrapper.dart';
import 'models.dart';
import 'package:location/location.dart';
import 'constants.dart' as Constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  void init() {}

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('init');
    setup();
  }

  void saveData(data) {
    print('$data');
    mqttClientWrapper.publishLocationEx(data);
  }

  MQTTClientWrapper mqttClientWrapper;
  LocationWrapper locationWrapper;

  LocationData currentLocation;

  void setup() {
    /*
    locationWrapper = LocationWrapper(
        (newLocation) => mqttClientWrapper.publishLocation(newLocation));
    */

    mqttClientWrapper = MQTTClientWrapper(
        () => locationWrapper.prepareLocationMonitoring(),
        (newLocationJson) => gotNewLocation(newLocationJson));

    mqttClientWrapper.prepareMqttClient();
  }

  void gotNewLocation(LocationData newLocationData) {
    setState(() {
      this.currentLocation = newLocationData;
      print('gotNewLocation');
    });
    // animateCameraToNewLocation(newLocationData);
  }

  void animateCameraToNewLocation(LocationData newLocation) {
    /*
    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            newLocation.latitude,
            newLocation.longitude
        ),
        zoom: Constants.newZoom
    )));
    */
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
            StreamBuilder<Geolocator.Position>(
                stream: Geolocator.getPositionStream(
                    desiredAccuracy: Geolocator.LocationAccuracy.high),
                builder: (BuildContext context,
                    AsyncSnapshot<Geolocator.Position> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasError) {
                    children = <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        children = <Widget>[
                          Icon(
                            Icons.info,
                            color: Colors.blue,
                            size: 60,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Select a lot'),
                          )
                        ];
                        break;
                      case ConnectionState.waiting:
                        children = <Widget>[
                          SizedBox(
                            child: const CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting geolocation data ...'),
                          )
                        ];
                        break;
                      case ConnectionState.active:
                        this.saveData(snapshot.data);
                        children = <Widget>[
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('${snapshot.data}'),
                          )
                        ];
                        break;
                      case ConnectionState.done:
                        children = <Widget>[
                          Icon(
                            Icons.info,
                            color: Colors.blue,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('${snapshot.data} (closed)'),
                          )
                        ];
                        break;
                    }
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  );
                })
          ],
        ),
      ),
    );
  }
}

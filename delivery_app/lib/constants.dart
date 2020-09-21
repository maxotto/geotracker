import 'package:location/location.dart';

final double defaultZoom = 10.8746;
final double newZoom = 15.8746;

final LocationData defaultLocation = new LocationData.fromMap(
    {'latitude': -6.1753871, 'longitude': 106.8249641});

final String defaultMarkerId = "1";

// final String serverUri = "ws://mikhailichenko.ru";
final String serverUri =
    "ws://ec2-18-218-34-205.us-east-2.compute.amazonaws.com";
final int port = 9001;
final String topicName = "delivery/andrey/location";

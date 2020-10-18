import 'package:flutter/foundation.dart';
import 'package:flutter_background/locationMqttPublisher.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'constants.dart' as Constants;
import 'package:uuid/uuid.dart';

class LocationService {
  factory LocationService() => _instance;
  LocationService._internal();

  static final _instance = LocationService._internal();
  static final _uuid = Uuid();

  ValueListenable<Geolocator.Position> get position =>
      _locationMqttPublisher.position;

  final _locationMqttPublisher = LocationMqttPublisher(
      Constants.serverUri,
      Constants.port,
      _uuid.v1(),
      Constants.topicName,
      (Geolocator.Position position) {});
}

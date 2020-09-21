import 'package:location/location.dart';

class LocationWrapper {
  var location = new Location();
  PermissionStatus _permissionGranted;
  final Function(LocationData) onLocationChanged;

  LocationWrapper(this.onLocationChanged);

  void prepareLocationMonitoring() async {
    _permissionGranted = await location.hasPermission();
    print(_permissionGranted);
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _subscribeToLocation();
  }

  void _subscribeToLocation() {
    location.onLocationChanged.listen((LocationData newLocation) {
      onLocationChanged(newLocation);
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/locationService.dart';

class LocationTab extends StatefulWidget {
  @override
  _LocationTabState createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('This is your location'),
          ValueListenableBuilder(
            valueListenable: LocationService().position,
            builder: (context, position, child) {
              return Text(
                position == null
                    ? "No data"
                    : position.latitude.toString() +
                        ', ' +
                        position.longitude.toString(),
              );
            },
          ),
        ]),
      ),
    );
  }
}

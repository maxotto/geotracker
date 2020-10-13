import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LocationMqttPublisher {
  final String serverUri;
  final int serverPort;
  final String clientId;
  final String topic;
  final Function(Geolocator.Position) onLocationChanged;

  bool isWaitingForConnection = false;

  MqttServerClient client;

  LocationMqttPublisher(this.serverUri, this.serverPort, this.clientId,
      this.topic, this.onLocationChanged) {
    this._setupMqttClient();
    StreamSubscription<Geolocator.Position> positionStream =
        Geolocator.getPositionStream(
                desiredAccuracy: Geolocator.LocationAccuracy.high)
            .listen((Geolocator.Position position) async {
      this.onLocationChanged(position);
      if (await this.ensureConnected()) {
        publish(position);
      }
    });
  }

  Future<bool> ensureConnected() async {
    if (this.isWaitingForConnection) {
      return false;
    }
    this.isWaitingForConnection = true;
    while (
        this.client.connectionStatus.state != MqttConnectionState.connected) {
      try {
        print('MQTTClientWrapper::Mosquitto client connecting....');
        await client.connect();
        print('MQTTClientWrapper::Mosquitto client connected');
      } on Exception catch (e) {
        print('MQTTClientWrapper::client exception - $e');
        print(
            'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${this.client.connectionStatus}');
        this.client.disconnect();
        await Future.delayed(Duration(seconds: 10));
      }
    }
    this.isWaitingForConnection = false;
    return true;
  }

  void publish(Geolocator.Position position) {
    final String message = jsonEncode(position);
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic $topic');
    this
        .client
        .publishMessage(this.topic, MqttQos.exactlyOnce, builder.payload);
  }

  void _setupMqttClient() {
    this.client = MqttServerClient.withPort(
      this.serverUri,
      this.clientId,
      this.serverPort,
    );
    this.client.logging(on: false);
    this.client.useWebSocket = true;

    this.client.keepAlivePeriod = 2000;
    this.client.onDisconnected = _onDisconnected;
    this.client.onConnected = _onConnected;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');
  }

  void _onConnected() {
    print(
        'MQTTClientWrapper::OnConnected client callback - Client connection was sucessful');
  }
}

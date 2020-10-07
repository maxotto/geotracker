import 'dart:async';
import 'dart:convert';

import 'package:delivery_app/models.dart';
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
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;

  LocationMqttPublisher(this.serverUri, this.serverPort, this.clientId,
      this.topic, this.onLocationChanged) {
    StreamSubscription<Geolocator.Position> positionStream =
        Geolocator.getPositionStream(
                desiredAccuracy: Geolocator.LocationAccuracy.high)
            .listen((Geolocator.Position position) async {
      this.onLocationChanged(position);
      if (await this.ensureConnected()) {
        publish(position);
      }
    });

    this._setupMqttClient();
  }

  Future<bool> ensureConnected() async {
    if (this.isWaitingForConnection) {
      return false;
    }
    this.isWaitingForConnection = true;
    while (client.connectionStatus.state != MqttConnectionState.connected) {
      try {
        print('MQTTClientWrapper::Mosquitto client connecting....');
        connectionState = MqttCurrentConnectionState.CONNECTING;
        await client.connect();
        print('MQTTClientWrapper::Mosquitto client connected');
      } on Exception catch (e) {
        print('MQTTClientWrapper::client exception - $e');
        connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
        print(
            'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
        client.disconnect();
        await Future.delayed(Duration(seconds: 10));
      }
    }
    connectionState = MqttCurrentConnectionState.CONNECTED;
    this.isWaitingForConnection = false;
    return true;
  }

  void publish(Geolocator.Position position) {
    final String message = jsonEncode(position);
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('MQTTClientWrapper::Publishing message $message to topic $topic');
    client.publishMessage(this.topic, MqttQos.exactlyOnce, builder.payload);
  }

  void _setupMqttClient() {
    MqttServerClient client = MqttServerClient.withPort(
      this.serverUri,
      this.clientId,
      this.serverPort,
    );
    client.logging(on: false);
    client.useWebSocket = true;

    client.keepAlivePeriod = 2000;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print(
        'MQTTClientWrapper::OnConnected client callback - Client connection was sucessful');
  }
}

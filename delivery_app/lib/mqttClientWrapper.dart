import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'models.dart';
import 'constants.dart' as Constants;
import 'package:location/location.dart';
import 'converter.dart';

class MQTTClientWrapper {
  MqttServerClient client;
  LocationToJsonConverter locationToJsonConverter = LocationToJsonConverter();
  JsonToLocationConverter jsonToLocationConverter = JsonToLocationConverter();

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  final VoidCallback onConnectedCallback;
  final Function(LocationData) onLocationReceivedCallback;

  MQTTClientWrapper(this.onConnectedCallback, this.onLocationReceivedCallback);

  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
    // _subscribeToTopic(Constants.topicName);
  }

  void publishLocation(LocationData locationData) {
    String locationJson = locationToJsonConverter.convert(locationData);
    _publishMessage(locationJson);
  }

  void publishLocationEx(Position input) {
    _publishMessage(jsonEncode(input));
  }

  Future<void> _connectClient() async {
    try {
      print('MQTTClientWrapper::Mosquitto client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect();
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('MQTTClientWrapper::Mosquitto client connected');
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(
      Constants.serverUri,
      '48a8fe09-2a80-412e-804e-3d5f7ea57a51',
      Constants.port,
    );
    client.logging(on: true);
    client.useWebSocket = true;

    client.keepAlivePeriod = 2000;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String newLocationJson =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print("MQTTClientWrapper::GOT A NEW MESSAGE $newLocationJson");
      LocationData newLocationData = _convertJsonToLocation(newLocationJson);
      if (newLocationData != null) onLocationReceivedCallback(newLocationData);
    });
  }

  LocationData _convertJsonToLocation(String newLocationJson) {
    try {
      return jsonToLocationConverter.convert(newLocationJson);
    } catch (exception) {
      print("Json can't be formatted ${exception.toString()}");
    }
    return null;
  }

  void _publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print(
        'MQTTClientWrapper::Publishing message $message to topic ${Constants.topicName}');
    client.publishMessage(
        Constants.topicName, MqttQos.exactlyOnce, builder.payload, true);
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
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
    onConnectedCallback();
  }
}

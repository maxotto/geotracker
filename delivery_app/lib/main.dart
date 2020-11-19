import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/app_retain_widget.dart';
import 'package:flutter_background/background_main.dart';
import 'package:flutter_background/collection_tab.dart';
import 'package:flutter_background/home_tab.dart';
import 'package:flutter_background/location_tab.dart';
import 'package:flutter_background/customer/profile_tab.dart';
import 'package:flutter_background/search_tab.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';

void main() {
  ShopifyConfig.setConfig(
      '71706cb7a1a093e4d676f1dd2f537864', // Storefront API access token.
      'mikhailichenko.myshopify.com', // Store url.
      '2020-10'); // The Shopify Storefront API version.

  runApp(MyApp());

  var channel = const MethodChannel('com.example/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location tracker',
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
  int _currentIndex = 0;

  final _tabs = [
    HomeTab(),
    CollectionTab(),
    SearchTab(),
    ProfileTab(),
    LocationTab(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location tracker'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationBarItemClick,
        fixedColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Collections"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_city), label: "Location"),
        ],
      ),
    );
  }

  void _onNavigationBarItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

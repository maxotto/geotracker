import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';

typedef void LogoutCallback();

class ProfilePage extends StatefulWidget {
  final LogoutCallback onUserLoggedOut;

  ProfilePage({@required this.onUserLoggedOut});

  @override
  State<StatefulWidget> createState() {
    return new ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  ShopifyUser _user;

  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(children: [
      //TODO для показа придумать члены класса, которые будут вычисляться из _user, а не тянуть из него данные напрямую
      Text(_user.displayName),
      Text(_user.createdAt),
      Text(_user.email),
      // Text(_user.phone),
      RaisedButton(
        textColor: Colors.white,
        color: Colors.blue,
        child: Text('Logout'),
        onPressed: () {
          this._logout();
          widget.onUserLoggedOut();
        },
      ),
    ]);
  }

  Future<void> _logout() async {
    ShopifyAuth shopifyAuth = ShopifyAuth.instance;
    await shopifyAuth.signOutCurrentUser();
  }

  Future<void> _getUser() async {
    ShopifyAuth shopifyAuth = ShopifyAuth.instance;
    ShopifyUser user = await shopifyAuth.currentUser();
    if (mounted) {
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
    }
  }
}

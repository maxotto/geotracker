import 'package:flutter/material.dart';
import 'package:flutter_background/customer/login_page.dart';
import 'package:flutter_background/customer/profile_page.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isLoading = false;
  bool _isLogged = false;
  ShopifyUser _user;

  @override
  void initState() {
    // Первичная однократная проверка, что мы залогинены
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : (_isLogged
                  ? ProfilePage(
                      onUserLoggedOut: () {
                        _updateLoginState(null);
                      },
                    )
                  : LoginPage(
                      onUserLogged: (ShopifyUser user) {
                        _updateLoginState(user);
                      },
                    ))),
    );
  }

  _updateLoginState(ShopifyUser user) {
    print("user changed");
    print(user);
    setState(() {
      _user = user;
      _isLogged = (user != null);
    });
  }

  Future<void> _getUser() async {
    ShopifyAuth shopifyAuth = ShopifyAuth.instance;
    ShopifyUser user = await shopifyAuth.currentUser();
    if (mounted) {
      if (user != null) {
        setState(() {
          _isLogged = true;
          _user = user;
        });
      }
    }
  }
}

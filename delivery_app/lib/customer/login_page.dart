import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';

typedef void UserCallback(ShopifyUser user);

class LoginPage extends StatefulWidget {
  final UserCallback onUserLogged;

  LoginPage({@required this.onUserLogged});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ShopifyUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Login, please!',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User`s EMail',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('Login'),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                    this._login();
                  },
                )),
          ],
        ));
  }

  Future<void> _login() async {
    print('Try to login');
    try {
      ShopifyAuth shopifyAuth = ShopifyAuth.instance;
      final ShopifyUser _user = await shopifyAuth.signInWithEmailAndPassword(
          email: nameController.text, password: passwordController.text);
      if (mounted) {
        setState(() {
          user = _user;
          widget.onUserLogged(user);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

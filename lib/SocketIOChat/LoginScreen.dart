import 'package:flutter/material.dart';
import 'ChartUsersScreen.dart';
import 'Global.dart';
import 'User.dart';

class ChatLoginScreen extends StatefulWidget {
  ChatLoginScreen() : super();
  static const String ROUTE_ID = 'chat_login_screen';
  @override
  _ChatLoginScreenState createState() => _ChatLoginScreenState();
}

class _ChatLoginScreenState extends State<ChatLoginScreen> {
  TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    G.intDummyUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let\'s chat"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(20.0),
              ),
            ),
            SizedBox(height: 20.0),
            OutlineButton(
                child: Text('LOGIN'),
                onPressed: () {
                  _loginTap();
                })
          ],
        ),
      ),
    );
  }

  _loginTap() {
    if (_usernameController.text.isEmpty) {
      return;
    }
    User me = G.dummyUsers[0];
    if (_usernameController.text != 'a') {
      me = G.dummyUsers[1];
    }

    G.loggedInUser = me;
    _openChatUserListScreen(context);
  }

  _openChatUserListScreen(context) async {
    await Navigator.pushReplacementNamed(context, ChatUsersScreen.ROUTE_ID);
  }
}
//

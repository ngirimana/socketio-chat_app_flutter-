import 'package:flutter/material.dart';

import 'ChatScreen.dart';
import 'Global.dart';
import 'LoginScreen.dart';
import 'User.dart';

class ChatUsersScreen extends StatefulWidget {
  ChatUsersScreen() : super();
  static const String ROUTE_ID = 'Chat_Users_screen';
  @override
  _ChatUsersScreenState createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  List<User> _chatUsers;
  bool _connectedToSocket;
  String _connectMessage;
  @override
  void initState() {
    super.initState();
    _connectedToSocket = false;
    _connectMessage = 'Connecting...';
    _chatUsers = G.getUsersFor(G.loggedInUser);
    _connectTosocket();
  }

  _connectTosocket() async {
    G.initSocket();
    await G.socketUtils.initSocket(G.loggedInUser);
    G.socketUtils.connectToSocket();
    G.socketUtils.setOnconnectListener(onConnect);
    G.socketUtils.setOnConnectionErrorListener(onConnectionError);
    G.socketUtils.setOnconnectionTimeOutListener(onConnectionTimeout);
    G.socketUtils.setOnDisconnectListener(onDisconnect);
    G.socketUtils.setOnErrorListener(onError);
  }

  onConnect(data) {
    setState(() {
      _connectedToSocket = true;
      _connectMessage = 'Connected';
    });
  }

  onConnectionError(data) {
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Connection Error';
    });
  }

  onConnectionTimeout(data) {
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Connection Timeout';
    });
  }

  onError(data) {
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Connection Error';
    });
  }

  onDisconnect(data) {
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Disconnected';
    });
  }

  _openChatScreen(context) async {
    await Navigator.pushNamed(context, ChatScreen.ROUTE_ID);
  }

  _openLoginScreen(context) async {
    await Navigator.pushReplacementNamed(context, ChatLoginScreen.ROUTE_ID);
  }

  @override
  void dispose() {
    super.dispose();
    G.socketUtils.closeConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Users"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _openLoginScreen(context);
              })
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Text(_connectedToSocket ? 'Connected' : _connectMessage),
            Expanded(
              child: ListView.builder(
                itemCount: _chatUsers.length,
                itemBuilder: (context, index) {
                  User user = _chatUsers[index];
                  return ListTile(
                    onTap: () {
                      G.toChatUser = user;
                      _openChatScreen(context);
                    },
                    title: Text(user.name),
                    subtitle: Text('ID ${user.id}, email:${user.email}'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
//

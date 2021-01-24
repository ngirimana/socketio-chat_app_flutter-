import 'dart:async';
import 'package:flutter/material.dart';

import 'ChatBubble.dart';
import 'ChatMessageModel.dart';
import 'ChatTitle.dart';
import 'Global.dart';
import 'SocketUtils.dart';
import 'User.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen() : super();
  static const String ROUTE_ID = 'Chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessageModel> _chatMessages;
  User _toChatUser;
  UserOnlineStatus _userOnlineStatus;
  TextEditingController _chatTextController;
  ScrollController _chatListController;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _removeListeners();
  }

  @override
  void initState() {
    super.initState();
    _chatMessages = List();
    _chatTextController = TextEditingController();
    _chatListController = ScrollController(initialScrollOffset: 0);
    _toChatUser = G.toChatUser;
    _userOnlineStatus = UserOnlineStatus.connecting;
    _initSocketListeners();
    _checkOnline();
  }

  _chatBubble(ChatMessageModel chatMessageModel) {
    bool fromMe = chatMessageModel.from == G.loggedInUser.id;
    Alignment alignment = fromMe ? Alignment.topRight : Alignment.topLeft;
    Alignment chatArrowAlignment =
        fromMe ? Alignment.topRight : Alignment.topLeft;
    TextStyle textStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    );
    Color chatBgColor = fromMe ? Colors.blue : Color.fromRGBO(62, 64, 66, 1);
    EdgeInsets edgeInsets = fromMe
        ? EdgeInsets.fromLTRB(5, 5, 15, 5)
        : EdgeInsets.fromLTRB(15, 5, 5, 5);
    EdgeInsets margins = fromMe
        ? EdgeInsets.fromLTRB(25, 5, 10, 5)
        : EdgeInsets.fromLTRB(10, 5, 25, 5);

    return Container(
      margin: margins,
      child: Align(
        alignment: alignment,
        child: Column(
          children: <Widget>[
            CustomPaint(
              painter: ChatBubble(
                color: chatBgColor,
                alignment: chatArrowAlignment,
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: edgeInsets,
                      child: Text(
                        chatMessageModel.message,
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _clearMessage() {
    _chatTextController.text = '';
  }

  _checkOnline() {
    ChatMessageModel chatMessageModel = ChatMessageModel(
        chatId: 0,
        to: _toChatUser.id,
        from: G.loggedInUser.id,
        toUserOnlineStatus: false,
        message: '',
        chatType: SocketUtils.SINGLE_CHAT);
    G.socketUtils.checkOnline(chatMessageModel);
  }

  _initSocketListeners() async {
    G.socketUtils.setOnChatMessageReceived(onChatMessageReceived);
    G.socketUtils.setOnlineUserStatusListener(onUserStatus);
  }

  _removeListeners() {
    G.socketUtils.setOnChatMessageReceived(null);
    G.socketUtils.setOnlineUserStatusListener(null);
  }

  onUserStatus(data) {
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    setState(() {
      _userOnlineStatus = chatMessageModel.toUserOnlineStatus
          ? UserOnlineStatus.online
          : UserOnlineStatus.not_online;
    });
  }

  onChatMessageReceived(data) {
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    chatMessageModel.isFromMe = false;
    processMessage(chatMessageModel);
    _chatListScrollToBottom();
  }

  processMessage(chatMessageModel) {
    setState(() {
      _chatMessages.add(chatMessageModel);
    });
  }

  _chatListScrollToBottom() {
    Timer(Duration(microseconds: 100), () {
      if (_chatListController.hasClients) {
        _chatListController.animateTo(
            _chatListController.position.maxScrollExtent,
            duration: Duration(microseconds: 100),
            curve: Curves.decelerate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChatTitle(
            toChatUser: _toChatUser, userOnlineStatus: _userOnlineStatus),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _chatListController,
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  ChatMessageModel chatMessageModel = _chatMessages[index];
                  bool fromMe = chatMessageModel.isFromMe;
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    alignment:
                        fromMe ? Alignment.centerRight : Alignment.centerLeft,
                    margin: EdgeInsets.all(5.0),
                    child: _chatBubble(chatMessageModel),
                  );
                },
              ),
            ),
            _bottomChatArea()
          ],
        ),
      ),
    );
  }

  _bottomChatArea() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          _chatTextArea(),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendingBtnTap();
            },
          ),
        ],
      ),
    );
  }

  _sendingBtnTap() async {
    if (_chatTextController.text.isEmpty) {
      return;
    }
    ChatMessageModel chatMessageModel = ChatMessageModel(
        chatId: 0,
        to: _toChatUser.id,
        from: G.loggedInUser.id,
        toUserOnlineStatus: false,
        message: _chatTextController.text,
        chatType: SocketUtils.SINGLE_CHAT,
        isFromMe: true);

    processMessage(chatMessageModel);
    _clearMessage();
    G.socketUtils.sendingSingleChatMesssage(chatMessageModel);
    _chatListScrollToBottom();
  }

  _chatTextArea() {
    return Expanded(
      child: TextField(
        controller: _chatTextController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.white,
              width: 0.0,
            ),
          ),
          filled: true,
          contentPadding: EdgeInsets.all(10.0),
          hintText: 'Type message...',
        ),
      ),
    );
  }
}

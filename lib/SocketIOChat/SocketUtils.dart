import 'package:adhara_socket_io/adhara_socket_io.dart';

import 'ChatMessageModel.dart';
import 'User.dart';

class SocketUtils {
  static String _connectUrl = 'https://chata-app-flutter.herokuapp.com/';

  //EVENTS
  static const String _ON_MESSAGE_RECEIVED = "receive_message";
  static const String _IS_USER_ONLINE_EVENT = 'check_online';
  static const String EVENT_SINGLE_CHAT_MESSAGE = 'single_chat_message';
  static const String SUB_EVENT_IS_USER_CONNECTED = 'is_user_connected';
  //status
  static const int STATUS_MESSAGE_NOT_SENT = 1001;
  static const int STATUS_MESSAGE_SENT = 1002;

  //type of Chat
  static const String SINGLE_CHAT = "sinle_chat";

  User _fromUser;
  SocketIO _socket;
  SocketIOManager _manager;

  initSocket(User fromUser) async {
    this._fromUser = fromUser;

    await init();
  }

  init() async {
    _manager = SocketIOManager();
    final Map<String, String> userMap = {
      'from': _fromUser.id.toString(),
    };
    _socket = await _manager.createInstance(SocketOptions(_connectUrl,
        enableLogging: true,
        transports: [Transports.WEB_SOCKET],
        query: userMap));
  }

  connectToSocket() {
    if (null == _socket) {
      return;
    }
    _socket.connect();
  }

  setOnconnectListener(Function onConnect) {
    _socket.onConnect((data) {
      onConnect(data);
    });
  }

  setOnconnectionTimeOutListener(Function onConnectionTimeout) {
    _socket.onConnectTimeout((data) {
      onConnectionTimeout(data);
    });
  }

  setOnConnectionErrorListener(Function onConnectionError) {
    _socket.onConnectError((data) {
      onConnectionError(data);
    });
  }

  setOnErrorListener(Function onError) {
    _socket.onError((data) {
      onError(data);
    });
  }

  setOnDisconnectListener(Function onDisconnect) {
    _socket.onDisconnect((data) {
      onDisconnect(data);
    });
  }

  closeConnection() {
    if (null != _socket) {
      _manager.clearInstance(_socket);
    }
  }

  sendingSingleChatMesssage(ChatMessageModel chatMessageModel) {
    if (null == _socket) {
      return;
    }
    _socket.emit(EVENT_SINGLE_CHAT_MESSAGE, [chatMessageModel.toJson()]);
  }

  setOnChatMessageReceived(Function onMessageReceived) {
    if (null == onMessageReceived) {
      return;
    }
    _socket.on(_ON_MESSAGE_RECEIVED, (data) {
      onMessageReceived(data);
    });
  }

  setOnlineUserStatusListener(Function onUserStatus) {
    if (null == onUserStatus) {
      return;
    }
    _socket.on(SUB_EVENT_IS_USER_CONNECTED, (data) {
      onUserStatus(data);
    });
  }

  checkOnline(ChatMessageModel chatMessageModel) {
    if (null == _socket) {
      return;
    }
    _socket.emit(_IS_USER_ONLINE_EVENT, [chatMessageModel.toJson()]);
  }
}

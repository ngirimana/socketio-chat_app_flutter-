

import 'ChartUsersScreen.dart';
import 'ChatScreen.dart';
import 'LoginScreen.dart';

class Routes {
  static routes() {
    return {
      ChatLoginScreen.ROUTE_ID: (context) => ChatLoginScreen(),
      ChatUsersScreen.ROUTE_ID: (context) => ChatUsersScreen(),
      ChatScreen.ROUTE_ID: (context) => ChatScreen(),
    };
  }

  static initScreen() {
    return ChatLoginScreen.ROUTE_ID;
  }
}

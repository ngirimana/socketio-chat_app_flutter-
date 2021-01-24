import 'dart:convert';

ChatMessageModel chatMessageModelFromJson(String str) =>
    ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) =>
    json.encode(data.toJson());

class ChatMessageModel {
  ChatMessageModel({
    this.chatId,
    this.to,
    this.from,
    this.message,
    this.chatType,
    this.toUserOnlineStatus,
    this.isFromMe,
  });

  int chatId;
  int to;
  int from;
  String message;
  String chatType;
  bool toUserOnlineStatus;
  bool isFromMe;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        chatId: json["chat_Id"],
        to: json["to"],
        from: json["from"],
        message: json["message"],
        chatType: json["chat_type"],
        toUserOnlineStatus: json["to_user_online_status"],
      );

  Map<String, dynamic> toJson() => {
        "chat_Id": chatId,
        "to": to,
        "from": from,
        "message": message,
        "chat_type": chatType,
        "to_user_online_status": toUserOnlineStatus,
      };
}

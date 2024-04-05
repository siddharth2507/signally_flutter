import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signalbyt/pages/group_chat/fb_tables.dart';

class MessageChat {
  String name;
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;

  MessageChat({
    required this.name,
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirebaseTables.name: name,
      FirebaseTables.idFrom: idFrom,
      FirebaseTables.idTo: idTo,
      FirebaseTables.timestamp: timestamp,
      FirebaseTables.content: content,
      FirebaseTables.type: type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String name = doc.get(FirebaseTables.name);
    String idFrom = doc.get(FirebaseTables.idFrom);
    String idTo = doc.get(FirebaseTables.idTo);
    String timestamp = doc.get(FirebaseTables.timestamp);
    String content = doc.get(FirebaseTables.content);
    int type = doc.get(FirebaseTables.type);
    return MessageChat(
        name: name,
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        type: type);
  }
}

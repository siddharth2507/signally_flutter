import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalbyt/pages/group_chat/fb_tables.dart';
import 'package:signalbyt/pages/group_chat/message_chat.dart';

class ChatProvider extends ChangeNotifier {
  static ChatProvider instance = Get.find();

  final SharedPreferences? prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider(
      {required this.firebaseFirestore,
      this.prefs,
      required this.firebaseStorage});

  String? getPref(String key) {
    return prefs?.getString(key);
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream(int limit) {
    return firebaseFirestore
        .collection(FirebaseTables.roomUser)
        .orderBy(FirebaseTables.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(String content, int type,
   String mId, String adminUserId, String name) {
    print("adminUserId>>> $adminUserId");
    print("mId>>> $mId");
    DocumentReference documentReference = firebaseFirestore
        .collection(FirebaseTables.roomUser)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      name: name,
      idFrom:mId ,
      idTo: adminUserId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }
}

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}

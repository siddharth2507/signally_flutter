import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/constants/app_colors.dart';
import 'package:signalbyt/pages/group_chat/chat_page_arguments.dart';
import 'package:signalbyt/pages/group_chat/chat_provider.dart';
import 'package:signalbyt/pages/group_chat/fb_tables.dart';
import 'package:signalbyt/pages/group_chat/message_chat.dart';
import 'package:signalbyt/pages/group_chat/my_form_field.dart';

class GroupChatPage extends StatefulWidget {
  GroupChatPage({Key? key}) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage>
    with TickerProviderStateMixin {
  ///widget.arguments.mId;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  int _limitIncrement = 20;

  ///widget.arguments.groupId;

  bool isLoading = false;
  bool isShowSticker = false;
  bool isOnline = false;
  bool isRead = false;
  String imageUrl = "";
  int from = 0;
  ChatPageArguments? chatPageArguments;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    chatPageArguments = Get.arguments;
  }

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void onSendMessage(String content, int type, BuildContext context) {
    if (content.trim().isNotEmpty) {
      chatProvider.sendMessage(
          content, type, Get.arguments.mId, Get.arguments.mId,Get.arguments.mName);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      print('Nothing to send');
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirebaseTables.idFrom) !=
                chatPageArguments!.mId) || //currentUserId
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirebaseTables.idFrom) ==
                chatPageArguments!.mId) || //currentUserId
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == Get.arguments.mId) {
        // Right (my message)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            messageChat.type == TypeMessage.text
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: appColorYellow,
                                )),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 10 : 10,
                                right: 1),
                            child: Text(
                              messageChat.content,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      isLastMessageRight(index)
                          ? Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: Text(
                                DateFormat('hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(messageChat.timestamp))),
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  )
                : messageChat.type == TypeMessage.image
                    // Image
                    ? Container(
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(0))),
                          child: Material(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              messageChat.content,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: const BoxDecoration(
                                    // color: ColorConstants.greyColor2,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      //   color: ColorConstants.themeColor,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Material(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                        child: Image.asset(
                          'images/${messageChat.content}.gif',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
          ],
        );
      } else {
        // Left (peer message)
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  messageChat.type == TypeMessage.text
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: appColorYellow,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              )),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20 : 10,
                              right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageChat.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                messageChat.content,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      : messageChat.type == TypeMessage.image
                          ? Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: TextButton(
                                onPressed: () {
                                  /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullPhotoPage(url: messageChat.content),
                                    ),
                                  );*/
                                },
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(0))),
                                child: Material(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    messageChat.content,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: const BoxDecoration(
                                          //  color: ColorConstants.greyColor2,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        width: 200,
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            //color: ColorConstants.themeColor,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) =>
                                            Material(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                  bottom: isLastMessageRight(index) ? 20 : 10,
                                  right: 10),
                              child: Image.asset(
                                'images/${messageChat.content}.gif',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                ],
              ),
              // Time
              isLastMessageLeft(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 0, top: 0, bottom: 10),
                      child: Text(
                        DateFormat('hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(messageChat.timestamp))),
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Group Chat',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, height: 1.5)),
          ],
        ),
        actions: [],
      ),
      body: Column(
        children: [
          buildListMessage(),
          buildInput(),
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
        child: StreamBuilder<QuerySnapshot>(
      stream: chatProvider.getChatStream(_limit),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          listMessage = snapshot.data!.docs;
          if (listMessage.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data?.docs[index]),
              itemCount: snapshot.data?.docs.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return Center(
              child: Text(
                'No message here yet',
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
                // color: ColorConstants.themeColor,
                ),
          );
        }
      },
    ));
  }

  Widget buildInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 22.0),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
            child: MyFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1)),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: appColorYellow, width: 1)),
                hintText: 'Type your message',
                hintStyle: TextStyle(
                    //color: appColorCardLight,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
              controller: textEditingController,
              fontSize: 15,
              labelText: 'message',
              maxLines: 1,
              textAlign: TextAlign.start,
              hintColor: appColorCardLight,
              //requireColor: appColorCardLight,
              onSubmited: (value) {
                onSendMessage(
                    textEditingController.text, TypeMessage.text, context);
              },
            ),
          ),
          const SizedBox(
            width: 4.0,
          ),

          // Button send message
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                shape: BoxShape.rectangle,
                border: Border.all(width: 1.0, color: appColorYellow)),
            child: InkWell(
              onTap: () {
                onSendMessage(
                    textEditingController.text, TypeMessage.text, context);
                textEditingController.clear();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 11, bottom: 11),
                child: Icon(Icons.send, color: appColorYellow, size: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatPageArguments {
  final String mId;
  final String mImage;
  final String adminId;
  final String mName;
  final String groupId;
  final String receiverUserToken;


  ChatPageArguments(
      {required this.mId,
        required this.mImage,
        required this.adminId,
        required this.mName,
        required this.groupId,
        required this.receiverUserToken,});
}
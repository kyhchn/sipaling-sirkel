class Message {
  String message;
  String uid;
  Message({required this.message, required this.uid});
  factory Message.RTDB(Map<String, dynamic> data) {
    return Message(
        message: data['message'], uid: data['uid']);
  }
}

class ChatModel{
  String msg;
  bool sender;
  ChatModel({
   required this.msg,
   required this.sender
  });

}
List<ChatModel> chat=[
  ChatModel(msg: "Hi", sender: false),
  ChatModel(msg: "Hi!", sender: true),
  ChatModel(msg: "How can i help you", sender: true),
  ChatModel(msg: "I'm interested in this item", sender: false),
];
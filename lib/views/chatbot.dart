import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black, title: Text("Chatbot",style: TextStyle(color: Colors.white),), centerTitle: true,)
    );
  }
}

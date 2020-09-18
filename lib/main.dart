import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // NEW

void main() {
  runApp(
    FriendlyChatApp(),
  );
}

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyChat',
      home: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});     // NEW
  final String text;            // NEW
  final AnimationController animationController;      // NEW
  String _name = 'Kanwar';
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.headline4),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  final List<ChatMessage> _messages = [];      // NEW
  final FocusNode _focusNode = FocusNode();    // NEW
  final _textController = TextEditingController();
  bool _isComposing = false;            // NEW
  Widget _buildTextComposer() {
    return  IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor), // NEW
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [Flexible(
            child: TextField(
              controller: _textController,
              onChanged: (String text) {            // NEW
                setState(() {                       // NEW
                  _isComposing = text.length > 0;   // NEW
                });                                 // NEW
              },                                    // NEW
              onSubmitted: _isComposing ? _handleSubmitted : null, // MODIFIED
              decoration: InputDecoration.collapsed(
                  hintText: 'Send a message'),
              focusNode: _focusNode,  // NEW
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: const Icon(Icons.send),
              onPressed: _isComposing                            // MODIFIED
                  ? () => _handleSubmitted(_textController.text) // MODIFIED
                  : null,
            )
          )],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                             // NEW
      _isComposing = false;                   // NEW
    });                                       // NEW
    ChatMessage message = ChatMessage(    //NEW
      text: text,                         //NEW
      animationController: AnimationController(      // NEW
        duration: const Duration(milliseconds: 500), // NEW
        vsync: this,                                 // NEW
      ),                                             // NEW
    );                                               //NEW
    setState(() {
      _messages.insert(0, message);       //NEW
    });
    _focusNode.requestFocus();  // NEW
    message.animationController.forward();           // NEW
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FriendlyChat')),
      body: Column(                                        // MODIFIED
        children: [                                        // NEW
          Flexible(                                        // NEW
            child: ListView.builder(                       // NEW
              padding: EdgeInsets.all(8.0),                // NEW
              reverse: true,                               // NEW
              itemBuilder: (_, int index) => _messages[index], // NEW
              itemCount: _messages.length,                 // NEW
            ),                                             // NEW
          ),                                               // NEW
          Divider(height: 1.0),                            // NEW
          Container(                                       // NEW
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor),         // NEW
            child: _buildTextComposer(),                   //MODIFIED
          ),                                               // NEW
        ],                                                 // NEW
      ),
    );
  }


  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SellerClientChatScreen extends StatefulWidget {
  @override
  _SellerClientChatScreenState createState() => _SellerClientChatScreenState();
}

class _SellerClientChatScreenState extends State
{
  TextEditingController _textController = TextEditingController();
  List<String> _chatList = [];
  List<String> _messages =[];
  late DatabaseReference _chatRef;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase database reference
    _chatRef = FirebaseDatabase.instance.reference().child('chatList');
    // Listen for changes in the database and update the messages list
    // Listen for changes in the database and update the messages list
    _chatRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          String messageText = (event.snapshot.value as Map<dynamic, dynamic>)['text'] ?? ''; // Ensure that 'text' is not null
          _messages.insert(0, messageText);
        });
      }
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _chatList.insert(0, text);
    });
    // Push message to Firebase database
    _chatRef.push().set({'text': text, 'sender': 'Contractor'}).catchError((error) {
      print('Failed to send message: $error');
    });

    _textController.clear();
  }


  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String messageText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            messageText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildChat(String messageText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            messageText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Client Chat', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF1F2544),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final messageText = _messages[index];
                  final isContractorMessage = _chatList.contains(messageText); // Assuming chatList contains messages from the Contractor
                  if (isContractorMessage) {
                    return _buildMessage(messageText);
                  } else {
                    return _buildChat(messageText);
                  }
                },
),
            ),
            Divider(height: 1.0),
            _buildTextComposer(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class ClientContractorChatScreen extends StatefulWidget {
  @override
  _ClientContractorChatScreenState createState() => _ClientContractorChatScreenState();
}

class _ClientContractorChatScreenState extends State<ClientContractorChatScreen> {
  TextEditingController _textController = TextEditingController();
  List<String> _messages = [];
  late DatabaseReference messagesRef;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase database reference
    messagesRef = FirebaseDatabase.instance.reference().child('messages');
    // Listen for changes in the database and update the messages list
    messagesRef.onChildAdded.listen((event) {
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

    // Update UI with the sent message

    // Push message to Firebase database
    messagesRef.push().set({'text': text, 'sender': 'client'}).catchError((error) {
      print('Failed to send message: $error');
      // If there's an error, remove the message from UI
      setState(() {
        _messages.remove(text);
      });
    });

    // Clear the text field after sending the message
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
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  _handleSubmitted(text);
                }
              },
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              String text = _textController.text.trim();
              if (text.isNotEmpty) {
                _handleSubmitted(text);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: Text(
            message,
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
                  return _buildMessage(_messages[index]);
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

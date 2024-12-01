import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChannelChatScreen extends StatefulWidget {
  final String channelName;

  const ChannelChatScreen({super.key, required this.channelName});

  @override
  _ChannelChatScreenState createState() => _ChannelChatScreenState();
}

class _ChannelChatScreenState extends State<ChannelChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late String channelName;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    channelName = widget.channelName;
    currentUser = FirebaseAuth.instance.currentUser!;
  }

  Future<void> sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    final userEmail = currentUser.email;

    final ref = FirebaseDatabase.instance
        .ref()
        .child('channels')
        .child(channelName)
        .child('messages')
        .push();

    await ref.set({
      'text': message,
      'sender': userEmail,
      'timestamp': ServerValue.timestamp,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat - $channelName'),
      ),
      body: Column(
        children: [
          // Real-time message list using StreamBuilder
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref()
                  .child('channels')
                  .child(channelName)
                  .child('messages')
                  .orderByChild('timestamp')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Make sure that snapshot data is available and of the correct type
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final data =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                  // If there is no data, show a message
                  if (data.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  // Convert the data into a list of messages
                  final messages = data.entries.map((entry) {
                    final message = entry.value;
                    return message;
                  }).toList();

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message['sender'] == currentUser.email;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display sender email
                            Text(
                              message['sender'] ?? 'Unknown Sender',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            // Display message text
                            Text(
                              message['text'],
                              style: TextStyle(
                                color: isMe ? Colors.blue : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No messages yet.'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

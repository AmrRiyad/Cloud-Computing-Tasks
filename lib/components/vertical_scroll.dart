import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ScrollableCardsPage extends StatefulWidget {
  @override
  _ScrollableCardsPageState createState() => _ScrollableCardsPageState();
}

class _ScrollableCardsPageState extends State<ScrollableCardsPage> {
  // List of card names (topics) and subscription states
  List<String> cardNames = [];
  List<bool> isSubscribed = [];

  @override
  void initState() {
    super.initState();
    // Fetch topics from Firestore
    fetchTopicsFromFirestore();
  }

  // Fetch topics from Firestore and update the cardNames list
  Future<void> fetchTopicsFromFirestore() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Assuming you have a collection named 'topics' in Firestore
      QuerySnapshot snapshot = await firestore.collection('Channels').get();

      // Extract topic names from documents
      List<String> topics = snapshot.docs
          .map((doc) =>
              doc.id as String) // Assuming the field is named 'topicName'
          .toList();

      // Update the UI with the fetched topics
      setState(() {
        cardNames = topics;
        isSubscribed = List.generate(cardNames.length, (index) => false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching topics: ${e.toString()}')),
      );
    }
  }

  // Toggle subscription state and perform the subscription/unsubscription
  Future<void> toggleSubscription(int index) async {
    final topic = cardNames[index];
    try {
      if (!isSubscribed[index]) {
        // Subscribe to the topic
        await FirebaseMessaging.instance.subscribeToTopic(topic);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscribed to $topic')),
        );
      } else {
        // Unsubscribe from the topic
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unsubscribed from $topic')),
        );
      }

      // Update the UI
      setState(() {
        isSubscribed[index] = !isSubscribed[index];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Function to show a dialog and add a new topic to Firestore
  void showAddChannelDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Channel'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter channel name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newChannelName = controller.text.trim();
                if (newChannelName.isNotEmpty) {
                  // Save the new channel to Firestore
                  await FirebaseFirestore.instance
                      .collection('Channels')
                      .doc(newChannelName)
                      .set({});

                  // Fetch the updated topics list
                  fetchTopicsFromFirestore();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Channel "$newChannelName" added!')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a channel name')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a topic from Firestore
  Future<void> deleteChannel(String channelName) async {
    try {
      // Delete the document using the channel name as the document ID
      await FirebaseFirestore.instance.collection('Channels').doc(channelName).delete();

      // Fetch the updated topics list
      fetchTopicsFromFirestore();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Channel "$channelName" deleted!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting channel: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cardNames.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cardNames.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Card title
                        Text(
                          cardNames[index],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        // Subscribe/Unsubscribe button
                        ElevatedButton(
                          onPressed: () => toggleSubscription(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSubscribed[index]
                                ? Colors.grey // Gray for "Unsubscribe"
                                : Colors.cyan, // Cyan for "Subscribe"
                          ),
                          child: Text(
                            isSubscribed[index] ? 'Unsubscribe' : 'Subscribe',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteChannel(cardNames[index]),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddChannelDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
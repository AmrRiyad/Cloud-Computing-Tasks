import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ScrollableCardsPage extends StatefulWidget {
  const ScrollableCardsPage({super.key});

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

  Future<void> fetchTopicsFromFirestore() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final userEmail = currentUser.email;
      if (userEmail == null) {
        throw Exception('User email not available');
      }

      final firestore = FirebaseFirestore.instance;

      // Fetch all available topics
      QuerySnapshot topicSnapshot = await firestore.collection('Channels').get();
      List<String> topics = topicSnapshot.docs.map((doc) => doc.id).toList();

      // Fetch user's subscribed channels
      DocumentSnapshot userDoc =
      await firestore.collection('users').doc(userEmail).get();
      List<String> userChannels = [];
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('channels')) {
          userChannels = List<String>.from(data['channels']);
        }
      }

      // Set state to update the UI
      setState(() {
        cardNames = topics;
        isSubscribed = topics.map((topic) => userChannels.contains(topic)).toList();
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
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final userEmail = currentUser.email; // Get the current user's email

    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User email not available')),
      );
      return;
    }

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(userEmail);

      if (!isSubscribed[index]) {
        // Subscribe to the topic
        await FirebaseMessaging.instance.subscribeToTopic(topic);

        // Add the topic to the channels list in Firestore
        await userDocRef.set(
          {
            'channels': FieldValue.arrayUnion([topic]),
          },
          SetOptions(merge: true), // Merge with existing data
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscribed to $topic')),
        );
      } else {
        // Unsubscribe from the topic
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic);

        // Remove the topic from the channels list in Firestore
        await userDocRef.set(
          {
            'channels': FieldValue.arrayRemove([topic]),
          },
          SetOptions(merge: true),
        );

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
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white, // Card background color
                    border: Border.all(color: Colors.cyan, width: 1.5), // Cyan border
                    borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Card title
                        Text(
                          cardNames[index],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        // Subscribe/Unsubscribe button
                        ElevatedButton(
                          onPressed: () => toggleSubscription(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSubscribed[index]
                                ? Colors.white // White for "Unsubscribe"
                                : Colors.cyan, // Cyan for "Subscribe"
                            side: const BorderSide(color: Colors.cyan, width: 1.5), // Cyan border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Rounded corners
                            ),
                          ),
                          child: Text(
                            isSubscribed[index] ? 'Unsubscribe' : 'Subscribe',
                            style: TextStyle(
                              color: isSubscribed[index] ? Colors.cyan : Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteChannel(cardNames[index]),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                )
                ;
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddChannelDialog,
        backgroundColor: Colors.white,
        foregroundColor: Colors.cyan,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Optional: Rounded corners
          side: const BorderSide(color: Colors.cyan, width: 1.5), // Cyan border
        ),
        child: const Icon(Icons.add),
      ),

    );
  }
}

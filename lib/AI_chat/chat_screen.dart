import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentalhealthtrackerapp/HomeScreen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _messages = [];
  String? _userId;
  String? _userAvatarUrl;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Replace with your backend URL
  final String backendUrl = "http://192.168.137.1:5000/api/chat";

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _userId = user.uid;

    // Fetch user avatar from Firestore
    final doc = await _db.collection("Users").doc(user.email).get();
    if (doc.exists) {
      final data = doc.data();
      setState(() {
        _userAvatarUrl = data?['photoUrl'];
      });
    }

    _fetchHistory();
  }

  // Fetch previous messages
  Future<void> _fetchHistory() async {
    if (_userId == null) return;
    try {
      final res = await http.get(Uri.parse("$backendUrl/history/$_userId"));
      if (res.statusCode == 200) {
        setState(() {
          _messages = List<Map<String, dynamic>>.from(jsonDecode(res.body));
        });
        _scrollToBottom();
      }
    } catch (e) {
      print("Failed to fetch history: $e");
    }
  }

  // Send a message
  Future<void> _sendMessage(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty || _userId == null) return;

    setState(() {
      _messages.add({
        "role": "user",
        "content": trimmedText,
        "timestamp": DateTime.now().toIso8601String()
      });
      _isLoading = true;
    });
    _scrollToBottom();
    _controller.clear();

    try {
      final res = await http.post(
        Uri.parse("$backendUrl/send"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": _userId, "message": trimmedText}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final aiMsg = data['aiMessage'];
        setState(() {
          _messages.add({
            "role": "assistant",
            "content": aiMsg['content'],
            "timestamp": aiMsg['timestamp']
          });
        });
        _scrollToBottom();
      } else {
        setState(() {
          _messages.add({
            "role": "assistant",
            "content": "Failed to get AI response",
            "timestamp": DateTime.now().toIso8601String()
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "assistant",
          "content": "Error: $e",
          "timestamp": DateTime.now().toIso8601String()
        });
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Center(child: const Text("Chat with AI")),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                final timestamp = DateTime.parse(msg['timestamp']);
                final timeStr =
                    "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";

                return Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser)
                      const CircleAvatar(
                          child: Icon(Icons.android)), // AI avatar
                    if (!isUser) const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['content'].length > 500
                                  ? msg['content'].substring(0, 500) + "..."
                                  : msg['content'],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                timeStr,
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isUser) const SizedBox(width: 8),
                    if (isUser)
                      CircleAvatar(
                        backgroundImage: _userAvatarUrl != null
                            ? NetworkImage(_userAvatarUrl!)
                            : null,
                        child: _userAvatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                  ],
                );
              },
            ),
          ),

          // Typing indicator
          if (_isLoading)
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.android)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("AI is typing..."),
                ),
              ],
            ),

          // Input field & send button
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 81, 62, 165),
                    size: 35,
                  ),
                  onPressed:
                      _isLoading ? null : () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_assisstant/helper/pref.dart';
import 'package:ai_assisstant/widget/custom_app_bar.dart';
import 'package:ai_assisstant/screens/service.dart'; // Assuming streamChatResponse is here

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  String? _error;
  bool _isSending = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;
  }

  Future<void> _sendMessage() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _error = null;
      _messages.add({'role': 'user', 'msg': prompt});
      _controller.clear();
      _messages.add({'role': 'ai', 'msg': ''}); // Placeholder for AI response
    });

    _scrollToBottom();

    final int aiIndex = _messages.length - 1;

    await streamChatResponse(
      prompt: prompt,
      onStreamUpdate: (partial) {
        setState(() {
          _messages[aiIndex]['msg'] = partial;
        });
        _scrollToBottom();
      },
      onError: (err) {
        setState(() {
          _error = err;
          // Remove the incomplete AI message if an error occurs
          if (_messages[aiIndex]['msg']!.isEmpty) {
            _messages.removeAt(aiIndex);
          }
          _isSending = false;
        });
      },
      onComplete: () {
        setState(() {
          _isSending = false;
        });
      },
    );
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

  /// Builds a single chat bubble for either user or AI.
  Widget _buildChatBubble(String text, bool isUser) {
    // Define some custom colors for consistency and better aesthetics
    final Color userBubbleColor = Theme.of(context).primaryColor;
    final Color aiBubbleColor = Colors.white; // A lighter color for AI
    final Color userTextColor = Colors.white;
    final Color aiTextColor = Colors.grey.shade800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Align to bottom for multiline messages
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // AI Avatar
          if (!isUser)
            CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.secondary.withOpacity(0.1),
              child: Icon(
                Icons.smart_toy_outlined, // A more modern AI icon
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
            ),
          SizedBox(width: isUser ? 0 : 8), // Spacing between avatar and bubble
          // Chat Bubble
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: isUser ? 60 : 0, // More margin for user messages
                right: isUser ? 0 : 60, // More margin for AI messages
              ),
              padding: const EdgeInsets.all(14), // Slightly more padding
              decoration: BoxDecoration(
                color: isUser ? userBubbleColor : aiBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18), // Slightly larger radius
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(
                    isUser ? 18 : 6,
                  ), // Pointed bottom for user
                  bottomRight: Radius.circular(
                    isUser ? 6 : 18,
                  ), // Pointed bottom for AI
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08), // Softer shadow
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? userTextColor : aiTextColor,
                  fontSize: 16,
                  height: 1.4, // Improve line spacing for readability
                ),
              ),
            ),
          ),
          SizedBox(width: isUser ? 8 : 0), // Spacing between avatar and bubble
          // User Avatar
          if (isUser)
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person_outline,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the input field for sending messages.
  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Light grey background for input
                borderRadius: BorderRadius.circular(28), // More rounded corners
                border: Border.all(
                  color: Colors.grey.shade200,
                ), // Subtle border
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Message AI Assistant...',
                  border: InputBorder.none, // Remove default border
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ), // Adjust padding
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                  ),
                ),
                maxLines: 5, // Allow more lines before scrolling
                minLines: 1,
                keyboardType: TextInputType.multiline, // Enable multiline input
                textCapitalization:
                    TextCapitalization.sentences, // Capitalize first letter
                onSubmitted: (_) => _sendMessage(),
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 10), // Increased spacing
          Material(
            // Use Material for better ripple effect
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(
              28,
            ), // Match text field curvature
            child: InkWell(
              onTap:
                  _isSending
                      ? null
                      : _sendMessage, // Disable tap during sending
              borderRadius: BorderRadius.circular(28),
              child: Container(
                padding: const EdgeInsets.all(14), // Larger tap target
                child:
                    _isSending
                        ? const SizedBox(
                          width: 24, // Larger progress indicator
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5, // Thicker stroke
                          ),
                        )
                        : const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 24,
                        ), // Larger icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Consistent background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // Adjust app bar height
        child: CustomAppBar(
          title: 'AI Assistant',
          rightIcon: Icons.light_mode_outlined,
          // You might want to add an onTap for the right icon, e.g., to toggle theme
          onRightIconTap: () {
            // Implement theme toggle or other functionality here
            print("Theme toggle tapped!");
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).scaffoldBackgroundColor,
                    ], // A subtle gradient or solid color
                  ),
                ),
                child:
                    _messages.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Start a conversation!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 12,
                          ), // More vertical padding
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            return AnimatedSize(
                              duration: const Duration(
                                milliseconds: 300,
                              ), // Smoother animation
                              curve: Curves.easeOut,
                              child: _buildChatBubble(
                                msg['msg']!,
                                msg['role'] == 'user',
                              ),
                            );
                          },
                        ),
              ),
            ),
            if (_error != null)
              Container(
                width: double.infinity, // Take full width
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                margin: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  8,
                ), // Margin for the error box
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12), // Rounded error box
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.red.shade700,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _error = null; // Allow user to dismiss error
                        });
                      },
                    ),
                  ],
                ),
              ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }
}

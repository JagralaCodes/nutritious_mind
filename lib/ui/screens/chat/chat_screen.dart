import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../../../data/services/gemini_service.dart';
import '../../../data/services/context_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final _gemini = GeminiService();

  final _quickPrompts = [
    'What should I eat for lunch?',
    'Is my breakfast healthy?',
    'Give me a light dinner idea',
    'How am I doing this week?',
    'Suggest a healthy snack',
  ];

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text.trim()});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final systemPrompt = ContextService.buildSystemPrompt();
      final response = await _gemini.sendMessage(
        messages: _messages,
        systemPrompt: systemPrompt,
      );
      setState(() {
        _messages.add({'role': 'assistant', 'content': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'assistant', 'content': 'Sorry, I couldn\'t connect right now. Check your internet and try again.'});
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(100.ms, () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text('🌿', style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(width: 10),
            Text('Meera', style: AppTypography.heading3),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == _messages.length && _isLoading) {
                        return _buildTypingIndicator();
                      }
                      final msg = _messages[i];
                      final isUser = msg['role'] == 'user';
                      return _MessageBubble(
                        text: msg['content']!,
                        isUser: isUser,
                      ).animate().fadeIn(duration: 300.ms).slideX(begin: isUser ? 0.1 : -0.1);
                    },
                  ),
          ),
          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Ask Meera anything...',
                        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        filled: false,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _sendMessage(_controller.text),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: Text('🌿', style: TextStyle(fontSize: 30))),
          ).animate().scale(begin: const Offset(0.5, 0.5), duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text('Hi! I\'m Meera', style: AppTypography.heading2)
              .animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text('Your personal nutrition advisor.\nAsk me anything about food!',
            style: AppTypography.bodySmall, textAlign: TextAlign.center)
              .animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickPrompts.map((p) => GestureDetector(
              onTap: () => _sendMessage(p),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(p, style: AppTypography.bodySmall.copyWith(color: Colors.white)),
              ),
            )).toList(),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => Container(
            width: 8, height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (c) => c.repeat())
              .fadeIn(delay: Duration(milliseconds: i * 200))
              .then()
              .fadeOut(delay: 400.ms)),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _MessageBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surface2,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Text(text, style: AppTypography.bodyMedium),
      ),
    );
  }
}

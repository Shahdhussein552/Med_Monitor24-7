import 'package:flutter/material.dart';

enum Sender { doctor, patient }
class ChatMessage { final String text; final Sender sender; const ChatMessage({required this.text, required this.sender}); }

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  static const Color _headerColor = Color(0xFF719EFF);
  static const Color _bgColor = Color(0xFFEDF3FF);
  static const Color _bubbleOther = Color(0xFFCADBFF);
  static const Color _bubbleMe = Color(0xFF719EFF);
  static const Color _textOther = Color(0xFF626262);
  static const Color _textMe = Color(0xFFFFFFFF);
  final List<ChatMessage> _messages = [const ChatMessage(text: 'hi, how can i help you', sender: Sender.doctor)];

  @override void dispose() { _inputController.dispose(); _scrollController.dispose(); super.dispose(); }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () { if (_scrollController.hasClients) { _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut); } });
  }

  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() { _messages.add(ChatMessage(text: text, sender: Sender.patient)); _inputController.clear(); });
    _scrollToBottom();
    Future.delayed(const Duration(seconds: 1), () { setState(() { _messages.add(const ChatMessage(text: 'I understand. Please tell me more about your symptoms.', sender: Sender.doctor)); }); _scrollToBottom(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(child: ListView.builder(controller: _scrollController, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), itemCount: _messages.length, itemBuilder: (context, index) => _buildBubble(_messages[index]))),
        _buildInputBar(),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(color: _headerColor, child: SafeArea(bottom: false, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [
      GestureDetector(onTap: () => Navigator.maybePop(context), child: const Icon(Icons.arrow_back, color: Colors.white, size: 24)),
      const SizedBox(width: 10),
      Container(width: 42, height: 42, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), image: const DecorationImage(image: AssetImage('assets/nurse (1).png'), fit: BoxFit.cover))),
      const SizedBox(width: 10),
      const Expanded(child: Text('Dr . Magdy Osama', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
    ]))));
  }

  Widget _buildBubble(ChatMessage msg) {
    final isRightSide = msg.sender == Sender.doctor;
    return Padding(padding: const EdgeInsets.only(bottom: 14), child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: isRightSide ? MainAxisAlignment.end : MainAxisAlignment.start, children: [
      Flexible(child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: isRightSide ? _bubbleOther : _bubbleMe, borderRadius: BorderRadius.only(topLeft: const Radius.circular(18), topRight: const Radius.circular(18), bottomLeft: Radius.circular(!isRightSide ? 4 : 18), bottomRight: Radius.circular(isRightSide ? 4 : 18))), child: Text(msg.text, textAlign: TextAlign.center, style: TextStyle(color: isRightSide ? _textOther : _textMe, fontSize: isRightSide ? 16 : 15, fontWeight: FontWeight.w600, height: 1.45)))),
      if (isRightSide) ...[const SizedBox(width: 8), Container(width: 38, height: 38, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, image: DecorationImage(image: AssetImage('assets/nurse (1).png'), fit: BoxFit.cover)))],
    ]));
  }

  Widget _buildInputBar() {
    return Container(color: _bgColor, padding: const EdgeInsets.fromLTRB(16, 10, 16, 24), child: Row(children: [
      Expanded(child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0xFFCADBFF), width: 1.5)), child: TextField(controller: _inputController, style: const TextStyle(fontSize: 14, color: Color(0xFF222222)), decoration: const InputDecoration(hintText: 'Type your message...', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12)), onSubmitted: (_) => _handleSend()))),
      const SizedBox(width: 10),
      GestureDetector(onTap: _handleSend, child: Container(width: 44, height: 44, decoration: BoxDecoration(color: _headerColor, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.send_rounded, color: Colors.white, size: 20))),
    ]));
  }
}
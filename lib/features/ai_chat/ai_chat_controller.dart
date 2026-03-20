import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/ai_chat_service.dart';
import '../../core/utils/error_handler.dart';
import '../../data/models/ai_chat_message_model.dart';

class AiChatController extends GetxController {
  final AiChatService _aiChatService = Get.find<AiChatService>();

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<AiChatMessageModel> messages = <AiChatMessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;

  StreamSubscription<List<AiChatMessageModel>>? _messagesSubscription;
  final List<AiChatMessageModel> _remoteMessages = <AiChatMessageModel>[];
  final List<AiChatMessageModel> _pendingMessages = <AiChatMessageModel>[];

  @override
  void onInit() {
    super.onInit();
    _listenToMessages();
  }

  void _listenToMessages() {
    final parentId = _aiChatService.currentParentId;
    if (parentId == null) {
      return;
    }

    isLoading.value = true;
    _messagesSubscription?.cancel();
    _messagesSubscription = _aiChatService.streamMessages(parentId).listen(
      (chatMessages) async {
        if (chatMessages.isEmpty) {
          final welcome = AiChatMessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: 'Hello! Ask me anything about your children, routines, behavior support, or sensory needs.',
            isUser: false,
            createdAt: DateTime.now(),
          );

          await _aiChatService.saveMessage(parentId: parentId, message: welcome);
          return;
        }

        _remoteMessages
          ..clear()
          ..addAll(chatMessages);
        _pendingMessages.removeWhere(
          (pending) => _remoteMessages.any((remote) => remote.id == pending.id),
        );
        _rebuildMessages();
        isLoading.value = false;
        _scrollToBottom();
      },
      onError: (error) {
        isLoading.value = false;
        ErrorHandler.showErrorSnackBar(error);
      },
    );
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) {
      return;
    }

    final parentId = _aiChatService.currentParentId;
    if (parentId == null) {
      ErrorHandler.showErrorSnackBar('No signed-in parent found.');
      return;
    }

    final userMessage = AiChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      isUser: true,
      createdAt: DateTime.now(),
    );
    final thinkingMessage = AiChatMessageModel(
      id: 'thinking_${DateTime.now().microsecondsSinceEpoch}',
      content: '',
      isUser: false,
      createdAt: DateTime.now().add(const Duration(milliseconds: 1)),
      isThinking: true,
    );

    messageController.clear();
    isSending.value = true;
    _pendingMessages.add(userMessage);
    _pendingMessages.add(thinkingMessage);
    _rebuildMessages();
    _scrollToBottom();

    try {
      await _aiChatService.saveMessage(parentId: parentId, message: userMessage);

      final reply = await _aiChatService.generateReply(
        parentMessage: text,
        history: [..._remoteMessages, ..._pendingMessages.where((message) => !message.isThinking)],
      );

      _pendingMessages.removeWhere((message) => message.id == thinkingMessage.id);

      final aiMessage = AiChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: reply,
        isUser: false,
        createdAt: DateTime.now(),
      );

      _pendingMessages.add(aiMessage);
      _rebuildMessages();
      await _aiChatService.saveMessage(parentId: parentId, message: aiMessage);
      _scrollToBottom();
    } catch (e) {
      _pendingMessages.removeWhere((message) => message.id == thinkingMessage.id);
      _rebuildMessages();
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> clearChat() async {
    final parentId = _aiChatService.currentParentId;
    if (parentId == null) {
      return;
    }

    try {
      await _aiChatService.clearMessages(parentId);
    } catch (e) {
      ErrorHandler.showErrorSnackBar(e);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _rebuildMessages() {
    final merged = <String, AiChatMessageModel>{};

    for (final message in _remoteMessages) {
      merged[message.id] = message;
    }

    for (final message in _pendingMessages) {
      merged.putIfAbsent(message.id, () => message);
    }

    final sortedMessages = merged.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    messages.assignAll(sortedMessages);
  }

  @override
  void onClose() {
    _messagesSubscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

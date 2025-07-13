class ChatRequest {
  final String message;
  final String? userId;

  ChatRequest({required this.message, this.userId});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
    };
  }
}
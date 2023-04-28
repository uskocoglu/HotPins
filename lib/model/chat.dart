class Chat {
  final String name, image, id, doc_id;
  final List<String> messages;
  final List<bool> who_send;
  final bool is_user1;

  Chat({
    required this.name,
    required this.id,
    required this.messages,
    required this.who_send,
    this.image = '',
    required this.doc_id,
    required this.is_user1,

  });
}


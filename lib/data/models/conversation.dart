import 'package:hive/hive.dart';
import 'message.dart';

part 'conversation.g.dart';

@HiveType(typeId: 4)
class Conversation extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<Message> messages;

  @HiveField(2)
  String summary;

  @HiveField(3)
  DateTime date;

  Conversation({
    required this.id,
    List<Message>? messages,
    this.summary = '',
    DateTime? date,
  })  : messages = messages ?? [],
        date = date ?? DateTime.now();
}

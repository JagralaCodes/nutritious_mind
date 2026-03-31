import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String role; // 'user' or 'assistant'

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime timestamp;

  Message({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });
}

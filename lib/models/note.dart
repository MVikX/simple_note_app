import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  bool isFavorite;

  @HiveField(3)
  bool isMarked;

  Note({
    required this.title,
    required this.content,
    this.isFavorite = false,
    this.isMarked = false,
  });
}
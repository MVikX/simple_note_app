import 'package:flutter/material.dart';
import 'package:first_flutter/models/note.dart';
import '../../../animations/home_screen/swipe_action_card.dart';
import '../../note/note_screen.dart';
import '../constans/home_constants.dart';
import 'note_card.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final void Function(int key) onDismissed;
  final void Function(int key) onMarked;

  const NoteList({
    super.key,
    required this.notes,
    required this.onDismissed,
    required this.onMarked,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: notes.map((note) {
        final noteKey = note.key as int;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultSpacing,
          ),
          child: SizedBox(
            width: double.infinity,
            child: SwipeActionCard(
              key: ValueKey("note_$noteKey"),
              onDismissed: () => onDismissed(noteKey),
              onMarked: () => onMarked(noteKey),
              onTap: () {
                if (!note.isMarked) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteScreen(note: note),
                    ),
                  );
                }
              },
              child: NoteCard(
                note: note,
                isMarked: note.isMarked,
                isFavorite: note.isFavorite,
                onFavoriteToggle: () async {
                  note.isFavorite = !note.isFavorite;
                  await note.save();
                },
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
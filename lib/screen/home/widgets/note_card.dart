import 'package:flutter/material.dart';
import 'package:first_flutter/models/note.dart';

import '../constans/home_constants.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool isMarked;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const NoteCard({
    super.key,
    required this.note,
    required this.isMarked,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: cardAnimDuration,
      decoration: BoxDecoration(
        color: isMarked ? markedBackgroundColor : theme.cardColor,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: isMarked ? markedBorderColor : defaultBorderColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: isMarked ? Colors.grey : null,
                      decoration: isMarked
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: defaultSpacing),
                  Text(
                    note.content,
                    maxLines: previewMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isMarked
                          ? Colors.grey
                          : theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onFavoriteToggle,
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
              ),
              tooltip: isFavorite ? "Remove from favorites" : "To Favorites",
            ),
          ],
        ),
      ),
    );
  }
}
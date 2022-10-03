// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_timeline/gg_timeline.dart';
import 'package:gg_typedefs/gg_typedefs.dart';
import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';

typedef GgNoteItem = GgTimelineItem<List<Note>>;

// #############################################################################
class _NoteEvent {
  const _NoteEvent({
    required this.timePosition,
    required this.note,
    required this.part,
    required this.measure,
    required this.isBegin,
  });

  final GgSeconds timePosition;
  final Note note;
  final Part part;
  final Measure measure;
  final bool isBegin;
}

// #############################################################################
/// Calculates items for a given time and a given part
class GgNoteItems extends GgTimeline<List<Note>> {
  // ...........................................................................
  /// - [part] is the document the items are generated for
  /// - [frameDuration] the time window considered for the item
  GgNoteItems({
    required this.part,
  }) {
    _init();
  }

  final Part part;

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init() {
    _initNoteItems();
  }

  // ...........................................................................
  void _initNoteItems() {
    final activeNotes = <Note>[];

    // Iterate all note events
    for (final noteEvent in _noteEvents) {
      final note = noteEvent.note;

      // Add/remove note on/off events to active notes
      if (noteEvent.isBegin) {
        activeNotes.add(note);
      } else {
        activeNotes.remove(note);
      }

      // Create a items containing all active notes
      addOrReplaceItem(
        data: [...activeNotes],
        timePosition: noteEvent.timePosition,
      );
    }

    jumpToBeginning();
  }

  // ...........................................................................
  @override
  List<Note> get seed => [];

  // ...........................................................................
  List<_NoteEvent> get _noteEvents {
    final noteEvents = <_NoteEvent>[];

    for (final measure in part.measures) {
      for (final note in measure.notes) {
        // Add start event
        final noteOnEvent = _NoteEvent(
          timePosition: note.noteDuration.timePosition,
          note: note,
          isBegin: true,
          measure: measure,
          part: part,
        );

        noteEvents.add(noteOnEvent);

        // Add stop event
        final noteOffEvent = _NoteEvent(
          timePosition:
              note.noteDuration.timePosition + note.noteDuration.seconds,
          note: note,
          isBegin: false,
          measure: measure,
          part: part,
        );

        noteEvents.add(noteOffEvent);
      }
    }

    return noteEvents
      ..sort(
        (a, b) => a.timePosition.compareTo(b.timePosition),
      );
  }
}

// #############################################################################
GgNoteItems exampleNoteTimeline() => GgNoteItems(
      part: wholePieceXmlDoc.parts.first,
    );

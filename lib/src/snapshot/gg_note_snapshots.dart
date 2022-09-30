// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_snapshot.dart';
import 'gg_snapshot_handler.dart';
import 'typedefs.dart';

typedef GgNoteSnapshot = GgSnapshot<List<Note>>;

// #############################################################################
class _NoteEvent {
  const _NoteEvent({
    required this.timePosition,
    required this.note,
    required this.part,
    required this.measure,
    required this.isBegin,
  });

  final Seconds timePosition;
  final Note note;
  final Part part;
  final Measure measure;
  final bool isBegin;
}

// #############################################################################
/// Calculates snapshots for a given time and a given part
class GgNoteSnapshots extends GgSnapshotHandler<List<Note>> {
  // ...........................................................................
  /// - [part] is the document the snapshots are generated for
  /// - [frameDuration] the time window considered for the snapshot
  GgNoteSnapshots({
    required super.part,
  }) {
    _init();
  }

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init() {
    _initNoteSnapshots();
  }

  // ...........................................................................
  void _initNoteSnapshots() {
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

      // Create a snapshots containing all active notes
      addOrReplaceSnapshot(
        data: [...activeNotes],
        timePosition: noteEvent.timePosition,
        measure: currentSnapshot.measure,
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
GgNoteSnapshots exampleNoteSnapshots() => GgNoteSnapshots(
      part: wholePieceXmlDoc.parts.first,
    );

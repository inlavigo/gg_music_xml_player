// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_snapshot.dart';
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
class GgNoteSnapshots {
  // ...........................................................................
  /// - [part] is the document the snapshots are generated for
  /// - [frameDuration] the time window considered for the snapshot
  GgNoteSnapshots({
    required this.part,
    this.frameDuration = const Duration(milliseconds: 20),
  }) {
    _init();
  }

  // ...........................................................................
  /// Returns the snapshot for a given time
  GgNoteSnapshot snapshot({required Seconds timePosition}) {
    _moveToSnapshotAtOrBefore(timePosition);
    return _currentSnapshot;
  }

  // ...........................................................................
  List<GgNoteSnapshot> get snapshots => _snapshots;

  // ######################
  // Private
  // ######################

  // ...........................................................................
  final Part part;
  final Duration frameDuration;
  final _snapshots = <GgNoteSnapshot>[];

  // ...........................................................................
  var _indexOfCurrentSnapshot = 0;
  late GgNoteSnapshot _currentSnapshot;

  // ...........................................................................
  void _init() {
    _initFirstSnapshot();
    _initNoteSnapshots();
  }

  // ...........................................................................
  void _jumpToBeginning() {
    _currentSnapshot = _snapshots.first;
    _indexOfCurrentSnapshot = 0;
  }

  // ...........................................................................
  void _initNoteSnapshots() {
    _jumpToBeginning();

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
      _addOrReplaceSnapshot(_currentSnapshot.copyWith(
        timePosition: noteEvent.timePosition,
        data: [...activeNotes],
      ));
    }
  }

  // ...........................................................................
  void _initFirstSnapshot() {
    _currentSnapshot = _initialSnapShot;
    _indexOfCurrentSnapshot = 0;
    _snapshots.add(_currentSnapshot);
  }

  // ...........................................................................
  void _moveToSnapshotAtOrBefore(Seconds timePosition) {
    if (_currentSnapshot.timePosition == timePosition) {
      return;
    }

    final startIndex = _indexOfCurrentSnapshot;

    // Find or snapshot in future
    var index = startIndex;
    if (timePosition > _currentSnapshot.timePosition) {
      while (++index < _snapshots.length) {
        final snapShot = _snapshots[index];
        if (snapShot.timePosition > timePosition) {
          break;
        }
        _indexOfCurrentSnapshot = index;
        _currentSnapshot = snapShot;
      }
    }

    // Find snapshot in past
    else {
      while (--index >= 0) {
        final snapShot = _snapshots[index];
        _indexOfCurrentSnapshot = index;
        _currentSnapshot = snapShot;

        if (snapShot.timePosition <= timePosition) {
          break;
        }
      }
    }
  }

  // ...........................................................................
  bool _replaceLastSnapshot(GgNoteSnapshot snapshot) {
    if (snapshot.timePosition == _currentSnapshot.timePosition) {
      _currentSnapshot = snapshot;
      _snapshots[_indexOfCurrentSnapshot] = snapshot;
      return true;
    }

    return false;
  }

  // ...........................................................................
  void _addOrReplaceSnapshot(GgNoteSnapshot snapshot) {
    _moveToSnapshotAtOrBefore(snapshot.timePosition);

    // Just replace last snapshot when possible
    if (_replaceLastSnapshot(snapshot)) {
      return;
    }

    _snapshots.insert(_indexOfCurrentSnapshot + 1, snapshot);
  }

  // ...........................................................................
  GgNoteSnapshot get _initialSnapShot {
    final first = part.measures.first;
    Seconds timePosition = 0.0;
    var result = GgNoteSnapshot(
      timePosition: timePosition,
      part: part,
      measure: first,
      data: [],
    );

    return result;
  }

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

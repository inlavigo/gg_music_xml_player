// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import 'gg_example_xml.dart';
import 'gg_snapshot.dart';
import 'typedefs.dart';

class _NoteEvent {
  const _NoteEvent({
    required this.timePosition,
    required this.note,
    required this.part,
    required this.measure,
    required this.isNoteOn,
  });

  _NoteEvent get noteOff {
    assert(isNoteOn);

    return _NoteEvent(
      timePosition: timePosition + (note.noteDuration.seconds),
      note: note,
      part: part,
      measure: measure,
      isNoteOn: false,
    );
  }

  final Seconds timePosition;
  final Note note;
  final Part part;
  final Measure measure;
  final bool isNoteOn;
  bool get isNoteOff => !isNoteOn;
}

// #############################################################################
/// Calculates snapshots for a given time and a given part
class GgSnapshotCalculator {
  // ...........................................................................
  /// - [part] is the document the snapshots are generated for
  /// - [frameDuration] the time window considered for the snapshot
  GgSnapshotCalculator({
    required this.part,
    this.frameDuration = const Duration(milliseconds: 20),
  }) {
    _init();
  }

  // ...........................................................................
  /// Returns the snapshot for a given time
  GgSnapshot snapshot({required Seconds timePosition}) {
    _moveToSnapshotAtOrBefore(timePosition);
    return _currentSnapshot;
  }

  // ######################
  // Private
  // ######################

  // ...........................................................................
  final Part part;
  final Duration frameDuration;
  final _snapshots = <GgSnapshot>[];

  // ...........................................................................
  var _indexOfCurrentSnapshot = 0;
  late GgSnapshot _currentSnapshot;

  // ...........................................................................
  void _init() {
    _initNoteSnapshots();
  }

  // ...........................................................................
  void _initNoteSnapshots() {
    _initFirstSnapshot();

    final activeNotes = <Note>[];

    // Iterate all note events
    for (final noteEvent in _noteEvents) {
      final note = noteEvent.note;

      // Find or create a snapshot for the given time position
      _moveToSnapshotAtOrBefore(noteEvent.timePosition);

      // Add/remove note on/off events to active notes
      if (noteEvent.isNoteOn) {
        activeNotes.add(note);
      } else {
        activeNotes.remove(note);
      }

      // Create a snapshots containing all active notes
      _addOrReplaceSnapshot(_currentSnapshot.copyWith(
        timePosition: noteEvent.timePosition,
        notes: activeNotes,
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
      }
    }
  }

  // ...........................................................................
  bool _replaceLastSnapshot(GgSnapshot snapshot) {
    if (snapshot.timePosition == _currentSnapshot.timePosition) {
      _currentSnapshot = snapshot;
      _snapshots[_indexOfCurrentSnapshot] = snapshot;
      return true;
    }

    return false;
  }

  // ...........................................................................
  void _addOrReplaceSnapshot(GgSnapshot snapshot) {
    // Just replace last snapshot when possible
    if (_replaceLastSnapshot(snapshot)) {
      return;
    }

    for (int i = 0; i < _snapshots.length; i++) {
      final existingSnapshot = _snapshots[i];

      // Insert snapshot at the right time position
      if (existingSnapshot.timePosition > snapshot.timePosition) {
        _snapshots.insert(i, snapshot);
        return;
      }

      // Replace existing snapshot at same time position
      if (existingSnapshot.timePosition == snapshot.timePosition) {
        _snapshots[i] = snapshot;
      }
    }
  }

  // ...........................................................................
  GgSnapshot get _initialSnapShot {
    final first = part.measures.first;
    Seconds timePosition = 0.0;
    var result = GgSnapshot(
      timePosition: timePosition,
      frameDuration: frameDuration,
      part: part,
      measure: first,
      tempo: first.tempos.isNotEmpty
          ? first.tempos.first
          : Tempo(120, timePosition),
      keySignature: part.measures.first.keySignature ?? KeySignature(),
      notes: {},
      chordSymbol: null,
    );

    return result;
  }

  // ...........................................................................
  List<_NoteEvent> get _noteEvents {
    final noteEvents = <_NoteEvent>[];

    for (final measure in part.measures) {
      for (final note in measure.notes) {
        bool hasTie = note.ties.isNotEmpty;
        bool hasEndTie = hasTie && note.ties.first.type == StartStop.stop;
        bool hasStartTie = hasTie && note.ties.last.type == StartStop.start;

        bool needsNoteOn = !hasTie || !hasEndTie;
        bool needsNoteOff = !hasTie || !hasStartTie;

        // Add note on event
        if (needsNoteOn) {
          final noteOnEvent = _NoteEvent(
            timePosition: note.noteDuration.timePosition,
            note: note,
            isNoteOn: true,
            measure: measure,
            part: part,
          );

          noteEvents.add(noteOnEvent);
        }

        // Needs note off
        if (needsNoteOff) {
          final noteOffEvent = _NoteEvent(
            timePosition:
                note.noteDuration.timePosition + note.noteDuration.seconds,
            note: note,
            isNoteOn: false,
            measure: measure,
            part: part,
          );

          noteEvents.add(noteOffEvent);
        }
      }
    }

    return noteEvents
      ..sort(
        (a, b) => a.timePosition.compareTo(b.timePosition),
      );
  }
}

// #############################################################################
GgSnapshotCalculator exampleGgSnapshotGenerator() => GgSnapshotCalculator(
      part: exampleMusicXmlDocument.parts.first,
    );

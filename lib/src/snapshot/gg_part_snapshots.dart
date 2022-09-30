// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:math';

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_chord_snapshots.dart';
import 'gg_note_snapshots.dart';
import 'typedefs.dart';

// #############################################################################
/// Data of a GgPartSnapshot
class GgPartSnapshot {
  const GgPartSnapshot({
    required this.validFrom,
    required this.validTo,
    required this.chordSnapshot,
    required this.noteSnapshot,
  });

  final Seconds validFrom;
  final Seconds validTo;
  final GgChordSnapshot chordSnapshot;
  final GgNoteSnapshot noteSnapshot;
}

// #############################################################################
/// Manages all snapshots for a given part
class GgPartSnapshots {
  GgPartSnapshots({
    required this.part,
  })  : chordSnapshots = GgChordSnapshots(part: part),
        noteSnapshots = GgNoteSnapshots(part: part) {
    _init();
  }

  // ...........................................................................
  final Part part;
  final GgChordSnapshots chordSnapshots;
  final GgNoteSnapshots noteSnapshots;

  // ...........................................................................
  /// Returns the snapshot for a given position
  GgPartSnapshot snapshot(Seconds timePosition) {
    if (timePosition < _currentSnapshot.validFrom ||
        timePosition >= _currentSnapshot.validTo) {
      _jumpToOrBefore(timePosition);
    }

    return _currentSnapshot;
  }

  // ...........................................................................
  GgPartSnapshot get currentSnapshot => _currentSnapshot;

  // ######################
  // Private
  // ######################

  late GgPartSnapshot _currentSnapshot;

  // ...........................................................................
  void _init() {
    _jumpToOrBefore(0.0);
  }

  // ...........................................................................
  void _jumpToOrBefore(Seconds timePosition) {
    chordSnapshots.jumpToOrBefore(timePosition);
    final currentChordSnapshot = chordSnapshots.currentSnapshot;
    final nextChordSnapshot = chordSnapshots.nextSnapshot;

    noteSnapshots.jumpToOrBefore(timePosition);
    final currentNoteSnapshot = noteSnapshots.currentSnapshot;
    final nextNoteSnapshot = noteSnapshots.nextSnapshot;

    final latestStartTime = max(
      currentChordSnapshot.timePosition,
      currentNoteSnapshot.timePosition,
    );

    final earliestBeginOfNextSnapshot = min(
      nextChordSnapshot.timePosition,
      nextNoteSnapshot.timePosition,
    );

    _currentSnapshot = GgPartSnapshot(
      validFrom: latestStartTime,
      validTo: earliestBeginOfNextSnapshot,
      chordSnapshot: currentChordSnapshot,
      noteSnapshot: currentNoteSnapshot,
    );
  }
}

// #############################################################################
final exampleGgPartSnapshots = GgPartSnapshots(
  part: wholePieceXmlDoc.parts.first,
);

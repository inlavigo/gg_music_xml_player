// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_chord_snapshots.dart';
import 'gg_multi_snapshots.dart';
import 'gg_note_snapshots.dart';
import 'typedefs.dart';

// #############################################################################
/// Wrap GgPartSnapshot around GgMultiSnapshot
class GgPartSnapshot extends GgMultiSnapshot {
  const GgPartSnapshot({
    required super.data,
    required super.validFrom,
    required super.validTo,
    required this.noteSnapshot,
    required this.chordSnapshot,
  });

  // ...........................................................................
  final GgChordSnapshot chordSnapshot;
  final GgNoteSnapshot noteSnapshot;
}

// #############################################################################
/// Manages all snapshots for a given part
class GgPartSnapshots extends GgMultiSnapshots<GgMultiSnapshotData> {
  GgPartSnapshots({
    required this.part,
  }) : super(snapshotHandlers: [
          GgChordSnapshots(part: part),
          GgNoteSnapshots(part: part),
        ]) {
    _init();
  }

  // ...........................................................................
  final Part part;

  // ...........................................................................
  @override
  GgPartSnapshot get currentSnapshot => _currentSnapshot;

  // ######################
  // Private
  // ######################

  late GgPartSnapshot _currentSnapshot;

  // ...........................................................................
  void _init() {
    _updateCurrentSnapshot(0.0);
  }

  // ...........................................................................
  void _updateCurrentSnapshot(Seconds timePosition) {
    final multi = super.snapshot(timePosition);

    _currentSnapshot = GgPartSnapshot(
      data: multi.data,
      validFrom: multi.validFrom,
      validTo: multi.validTo,
      chordSnapshot: multi.data.elementAt(0) as GgChordSnapshot,
      noteSnapshot: multi.data.elementAt(1) as GgNoteSnapshot,
    );
  }
}

// #############################################################################
final exampleGgPartSnapshots = GgPartSnapshots(
  part: wholePieceXmlDoc.parts.first,
);

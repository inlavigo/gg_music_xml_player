// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_chord_snapshots.dart';
import 'gg_note_snapshots.dart';
import 'gg_snapshot.dart';
import 'gg_snapshot_handler.dart';
import 'typedefs.dart';

typedef GgPartSnapshotData = Iterable<GgSnapshot<dynamic>>;
typedef GgPartSnapshot = GgSnapshot<GgPartSnapshotData>;

extension GgPartSnapshotDataExtension on GgPartSnapshot {
  GgChordSnapshot get chordSnapshot => data.elementAt(0) as GgChordSnapshot;

  GgNoteSnapshot get noteSnapshot => data.elementAt(1) as GgNoteSnapshot;
}

// #############################################################################
/// Manages all snapshots for a given part
class GgPartSnapshots extends GgSnapshotHandler<GgPartSnapshotData> {
  GgPartSnapshots({
    required this.part,
  })  : chordSnapshots = GgChordSnapshots(part: part),
        noteSnapshots = GgNoteSnapshots(part: part) {
    _init();
  }

  // ...........................................................................
  final Part part;

  // ...........................................................................
  late Iterable<GgSnapshotHandler> snapshotHandlers;

  // ...........................................................................
  final GgChordSnapshots chordSnapshots;
  final GgNoteSnapshots noteSnapshots;

  // ...........................................................................
  @override
  GgPartSnapshotData get seed => [
        chordSnapshots.currentSnapshot,
        noteSnapshots.currentSnapshot,
      ];

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init() {
    snapshotHandlers = [chordSnapshots, noteSnapshots];
    _initSnapshots();
    jumpToOrBefore(0.0);
  }

  // ...........................................................................
  void _initSnapshots() {
    List<Seconds> times = [];

    // Collect all times where something changes
    for (final handler in snapshotHandlers) {
      for (final snapshot in handler.snapshots) {
        times.add(snapshot.validFrom);
      }
    }

    // Sort times
    times.sort(
      (a, b) => a.compareTo(b),
    );

    // For each time create a snapshot
    for (int i = 0; i < times.length; i++) {
      final validFrom = times[i];
      final data = <GgSnapshot>[];

      for (final handler in snapshotHandlers) {
        handler.jumpToOrBefore(validFrom);
        data.add(handler.currentSnapshot);
      }

      addOrReplaceSnapshot(data: data, validFrom: validFrom);
    }
  }
}

// #############################################################################
final exampleGgPartSnapshots = GgPartSnapshots(
  part: wholePieceXmlDoc.parts.first,
);

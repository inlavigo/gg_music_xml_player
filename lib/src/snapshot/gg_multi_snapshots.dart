// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:math';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_chord_snapshots.dart';
import 'gg_note_snapshots.dart';
import 'gg_snapshot.dart';
import 'gg_snapshot_handler.dart';
import 'typedefs.dart';

// #############################################################################
/// Data of a GgMultiSnapshot
class GgMultiSnapshot {
  const GgMultiSnapshot({
    required this.validFrom,
    required this.validTo,
    required this.snapshots,
  });

  final Seconds validFrom;
  final Seconds validTo;
  final List<GgSnapshot> snapshots;
}

// #############################################################################
/// Manages all snapshots for a given part
class GgMultiSnapshots {
  GgMultiSnapshots({
    required this.snapshotHandlers,
  }) {
    _init();
  }

  // ...........................................................................
  final List<GgSnapshotHandler> snapshotHandlers;

  // ...........................................................................
  /// Returns the snapshot for a given position
  GgMultiSnapshot snapshot(Seconds timePosition) {
    if (timePosition < _currentSnapshot.validFrom ||
        timePosition >= _currentSnapshot.validTo) {
      _jumpToOrBefore(timePosition);
    }

    return _currentSnapshot;
  }

  // ...........................................................................
  GgMultiSnapshot get currentSnapshot => _currentSnapshot;

  // ######################
  // Private
  // ######################

  late GgMultiSnapshot _currentSnapshot;

  // ...........................................................................
  void _init() {
    _jumpToOrBefore(0.0);
  }

  // ...........................................................................
  void _jumpToOrBefore(Seconds timePosition) {
    var validFrom = 0.0;
    var validTo = double.maxFinite;
    final snapshots = <GgSnapshot>[];

    for (final handler in snapshotHandlers) {
      handler.jumpToOrBefore(timePosition);
      validFrom = max(handler.currentSnapshot.validFrom, validFrom);
      validTo = min(handler.nextSnapshot.validFrom, validTo);
      snapshots.add(handler.currentSnapshot);
    }

    _currentSnapshot = GgMultiSnapshot(
      validFrom: validFrom,
      validTo: validTo,
      snapshots: snapshots,
    );
  }
}

// #############################################################################
final exampleGgMultiSnapshots = GgMultiSnapshots(snapshotHandlers: [
  GgChordSnapshots(part: wholePieceXmlDoc.parts.first),
  GgNoteSnapshots(part: wholePieceXmlDoc.parts.first),
]);

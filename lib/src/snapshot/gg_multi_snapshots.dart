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

// #############################################################################
/// Data of a GgMultiSnapshot
class GgMultiSnapshot extends GgSnapshot<Iterable<GgSnapshot>> {
  const GgMultiSnapshot({
    required super.validFrom,
    required super.validTo,
    required super.data,
  });

  List<GgSnapshot> get snapshots => data as List<GgSnapshot>;

  // ...........................................................................
  @override
  GgMultiSnapshot copyWith({
    Seconds? validFrom,
    Seconds? validTo,
    Part? part,
    Measure? measure,
    Iterable<GgSnapshot>? data,
  }) {
    return GgMultiSnapshot(
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      data: data ?? this.data,
    );
  }
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
  GgSnapshot get leadingChildSnapshot => _leadingChildSnapshot;

  // ######################
  // Private
  // ######################

  late GgMultiSnapshot _currentSnapshot;
  late GgSnapshot _leadingChildSnapshot;

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
      final current = handler.currentSnapshot;
      final next = handler.nextSnapshot;

      if (current.validFrom >= validFrom) {
        _leadingChildSnapshot = current;
        validFrom = current.validFrom;
      }

      if (validTo > next.validFrom) {
        validTo = next.validTo;
      }

      snapshots.add(handler.currentSnapshot);
    }

    _currentSnapshot = GgMultiSnapshot(
      validFrom: validFrom,
      validTo: validTo,
      data: snapshots,
    );
  }
}

// #############################################################################
final exampleGgMultiSnapshots = GgMultiSnapshots(snapshotHandlers: [
  GgChordSnapshots(part: wholePieceXmlDoc.parts.first),
  GgNoteSnapshots(part: wholePieceXmlDoc.parts.first),
]);

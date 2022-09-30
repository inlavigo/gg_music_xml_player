// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_chord_snapshots.dart';
import 'gg_note_snapshots.dart';
import 'gg_snapshot.dart';
import 'gg_snapshot_handler.dart';
import 'typedefs.dart';

// #############################################################################
typedef GgMultiSnapshotData<T> = Iterable<GgSnapshot<T>>;
typedef GgMultiSnapshot<T> = GgSnapshot<GgMultiSnapshotData<T>>;

// #############################################################################
/// Manages all snapshots for a given part
class GgMultiSnapshots<T> extends GgSnapshotHandler<GgMultiSnapshotData<T>> {
  GgMultiSnapshots({
    required this.snapshotHandlers,
  }) {
    _init();
  }

  // ...........................................................................
  final Iterable<GgSnapshotHandler> snapshotHandlers;

  // ...........................................................................
  /// Returns the snapshot for a given position
  @override
  GgMultiSnapshot<T> snapshot(Seconds timePosition) {
    _jumpToOrBefore(timePosition);
    return _currentSnapshot;
  }

  // ...........................................................................
  @override
  Iterable<GgSnapshot<T>> get seed => [];

  @override
  GgSnapshot<Iterable<GgSnapshot<T>>> get currentSnapshot => _currentSnapshot;

  // ######################
  // Private
  // ######################

  GgMultiSnapshot<T> _currentSnapshot = const GgMultiSnapshot(
    validFrom: 0,
    validTo: 0,
    data: [],
  );

  // ...........................................................................
  void _init() {
    _jumpToOrBefore(0.0);
  }

  // ...........................................................................
  void _jumpToOrBefore(Seconds timePosition) {
    if (timePosition >= _currentSnapshot.validFrom &&
        timePosition < _currentSnapshot.validTo) {
      return;
    }

    var validFrom = 0.0;
    var validTo = double.maxFinite;
    final snapshots = <GgSnapshot<T>>[];

    for (final handler in snapshotHandlers) {
      handler.jumpToOrBefore(timePosition);
      final current = handler.currentSnapshot;
      final next = handler.nextSnapshot;

      if (current.validFrom > validFrom) {
        validFrom = current.validFrom;
      }

      if (validTo > next.validFrom) {
        validTo = next.validFrom;
      }

      snapshots.add(handler.currentSnapshot as GgSnapshot<T>);
    }

    _currentSnapshot = GgMultiSnapshot<T>(
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

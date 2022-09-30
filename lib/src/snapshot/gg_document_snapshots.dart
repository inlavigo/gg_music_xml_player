// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_part_snapshots.dart';
import 'gg_snapshot.dart';
import 'gg_snapshot_handler.dart';
import 'typedefs.dart';

// #############################################################################
typedef GgDocumentSnapshotData = List<GgPartSnapshot>;
typedef GgDocumentSnapshot = GgSnapshot<GgDocumentSnapshotData>;

// #############################################################################
class GgDocumentSnapshots extends GgSnapshotHandler<GgDocumentSnapshotData> {
  GgDocumentSnapshots({
    required this.document,
  }) {
    _init();
  }

  // ...........................................................................
  final MusicXmlDocument document;

  // ...........................................................................
  late Iterable<GgPartSnapshots> snapshotHandlers;

  // ...........................................................................
  @override
  GgDocumentSnapshotData get seed => [];

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init() {
    snapshotHandlers = document.parts.map(
      (e) => GgPartSnapshots(part: e),
    );
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
      final GgDocumentSnapshotData data = [];

      for (final handler in snapshotHandlers) {
        handler.jumpToOrBefore(validFrom);
        data.add(handler.currentSnapshot);
      }

      addOrReplaceSnapshot(data: data, validFrom: validFrom);
    }
  }
}

// #############################################################################
final exampleGgDocumentSnapshots = GgDocumentSnapshots(
  document: wholePieceXmlDoc,
);

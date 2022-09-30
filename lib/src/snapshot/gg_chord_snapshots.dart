// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';
import 'package:collection/collection.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_snapshot.dart';
import 'gg_snapshot_handler.dart';

typedef GgChordSnapshot = GgSnapshot<ChordSymbol>;

/// Generates snapshots for chords
class GgChordSnapshots extends GgSnapshotHandler<ChordSymbol> {
  GgChordSnapshots({
    required super.part,
  }) {
    _init();
  }

  // ...........................................................................
  @override
  ChordSymbol get seed =>
      part.measures
          .firstWhereOrNull((element) => element.chordSymbols.isNotEmpty)
          ?.chordSymbols
          .first ??
      ChordSymbol(); // coverage:ignore-line

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init() {
    jumpToBeginning();
    for (final measure in part.measures) {
      for (final chordSymbol in measure.chordSymbols) {
        addOrReplaceSnapshot(
          timePosition: chordSymbol.timePosition,
          data: chordSymbol,
          measure: measure,
        );
      }
    }
  }
}

// #############################################################################
final exampleGgChordSnapshots = GgChordSnapshots(
  part: wholePieceXmlDoc.parts.first,
);

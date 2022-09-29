// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_snapshot.dart';
import 'gg_snapshot_parser.dart';

typedef GgChordSnapshot = GgSnapshot<ChordSymbol>;

/// Generates snapshots for chords
class GgChordSnapshots extends GgSnapshotParser<ChordSymbol> {
  GgChordSnapshots({
    required super.part,
    super.frameDuration,
  });

  // ...........................................................................
  @override
  ChordSymbol get seed => part.measures[1].chordSymbols.isNotEmpty
      ? part.measures[1].chordSymbols.first
      : ChordSymbol(); // coverage:ignore-line

  // ######################
  // Private
  // ######################

}

// #############################################################################
final exampleGgChordSnapshots = GgChordSnapshots(
  part: wholePieceXmlDoc.parts.first,
);

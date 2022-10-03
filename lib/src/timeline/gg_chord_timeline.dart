// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:collection/collection.dart';
import 'package:gg_timeline/gg_timeline.dart';
import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';

typedef GgChordItem = GgTimelineItem<ChordSymbol>;

/// Generates items for chords
class GgChordTimeline extends GgTimeline<ChordSymbol> {
  GgChordTimeline({
    required this.part,
  }) {
    _init();
  }

  // ...........................................................................
  final Part part;

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
    for (final measure in part.measures) {
      for (final chordSymbol in measure.chordSymbols) {
        addOrReplaceItem(
          timePosition: chordSymbol.timePosition,
          data: chordSymbol,
        );
      }
    }

    jumpToBeginning();
  }
}

// #############################################################################
final exampleGgChordTimeline = GgChordTimeline(
  part: wholePieceXmlDoc.parts.first,
);

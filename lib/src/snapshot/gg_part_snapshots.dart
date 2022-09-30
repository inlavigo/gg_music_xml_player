// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_chord_snapshots.dart';
import 'gg_note_snapshots.dart';

/// Manages all snapshots for a given part
class GgPartSnapshots {
  GgPartSnapshots({
    required this.part,
  })  : chordSnapshots = GgChordSnapshots(part: part),
        noteSnapshots = GgNoteSnapshots(part: part);

  final Part part;
  final GgChordSnapshots chordSnapshots;
  final GgNoteSnapshots noteSnapshots;
}

// #############################################################################
final exampleGgPartSnapshots = GgPartSnapshots(
  part: wholePieceXmlDoc.parts.first,
);

// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_part_snapshots.dart';

class GgDocumentSnapshots {
  GgDocumentSnapshots({
    required this.document,
  }) {
    _init();
  }

  // ...........................................................................
  final MusicXmlDocument document;

  /// Returns all part snapshots
  Iterable<GgPartSnapshots> get partSnapshots => _partSnapshots.values;

  // ######################
  // Private
  // ######################

  final _partSnapshots = <String, GgPartSnapshots>{};

  // ...........................................................................
  void _init() {
    for (var part in document.parts) {
      _partSnapshots[part.id] = GgPartSnapshots(part: part);
    }
  }
}

// #############################################################################
final exampleGgDocumentSnapshots = GgDocumentSnapshots(
  document: wholePieceXmlDoc,
);

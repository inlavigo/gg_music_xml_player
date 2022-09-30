// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_multi_snapshots.dart';
import 'gg_part_snapshots.dart';

// #############################################################################
typedef GgDocumentSnapshot = GgMultiSnapshot<GgPartSnapshot>;

// #############################################################################
class GgDocumentSnapshots extends GgMultiSnapshots<GgPartSnapshot> {
  GgDocumentSnapshots({
    required this.document,
  }) : super(
          snapshotHandlers: document.parts.map(
            (e) => GgPartSnapshots(part: e),
          ),
        ) {
    _init();
  }

  // ...........................................................................
  final MusicXmlDocument document;

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init() {}
}

// #############################################################################
final exampleGgDocumentSnapshots = GgDocumentSnapshots(
  document: wholePieceXmlDoc,
);

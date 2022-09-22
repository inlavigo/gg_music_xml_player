// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import 'gg_example_xml.dart';

/// Takes music xml  and yields past, current and future notes for a given time.
class GgSongTimeController {
  GgSongTimeController({
    required this.musicXmlDocument,
  }) {
    _init();
  }

  // ...........................................................................
  void dispose() {
    for (final d in _dispose.reversed) {
      d();
    }
  }

  // ######################
  // Private
  // ######################

  final List<Function()> _dispose = [];
  void _init() {
    _dispose.add(() {});
  }

  final MusicXmlDocument musicXmlDocument;
}

// #############################################################################
GgSongTimeController exampleGgSongTimeController({
  String document = ggExampleXmlString,
}) =>
    GgSongTimeController(
      musicXmlDocument: MusicXmlDocument.parse(document),
    );

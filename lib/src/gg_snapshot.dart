// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

/// Describes the situation in a music XML document at a given point of time
class GgSnapshot {
  const GgSnapshot({
    required this.voices,
    required this.measure,
    required this.tempo,
    required this.keySignature,
    required this.windowLength,
  });

  // ...........................................................................
  final Map<String, Iterable<Note>> voices;
  final Measure measure;
  final Tempo tempo;
  final KeySignature keySignature;
  final Duration windowLength;
}

// #############################################################################
final exampleGgSnapshot = GgSnapshot(
  voices: {},
  measure: Measure(),
  tempo: Tempo(120.0, 0.0),
  keySignature: KeySignature(),
  windowLength: const Duration(milliseconds: 100),
);

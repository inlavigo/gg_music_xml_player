// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import 'typedefs.dart';

/// Describes the situation in a music XML document at a given point of time
class GgSnapshot {
  const GgSnapshot({
    required this.timePosition,
    required this.frameDuration,
    required this.part,
    required this.measure,
    required this.tempo,
    required this.keySignature,
    required this.notes,
    required this.chordSymbol,
  });

  GgSnapshot copyWith({
    Seconds? timePosition,
    Duration? frameDuration,
    Part? part,
    Measure? measure,
    Tempo? tempo,
    KeySignature? keySignature,
    Iterable<Note>? notes,
    ChordSymbol? chordSymbol,
  }) {
    return GgSnapshot(
      timePosition: timePosition ?? this.timePosition,
      frameDuration: frameDuration ?? this.frameDuration,
      part: part ?? this.part,
      measure: measure ?? this.measure,
      tempo: tempo ?? this.tempo,
      keySignature: keySignature ?? this.keySignature,
      notes: notes ?? this.notes,
      chordSymbol: chordSymbol ?? this.chordSymbol,
    );
  }

  // ...........................................................................
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            (other is GgSnapshot) &&
            (other.timePosition == timePosition) &&
            (other.frameDuration == frameDuration) &&
            (other.part == part) &&
            (other.measure == measure) &&
            (other.tempo == tempo) &&
            (other.keySignature == keySignature) &&
            (other.notes == notes) &&
            (other.chordSymbol == chordSymbol));
  }

  // ...........................................................................
  @override
  int get hashCode =>
      timePosition.hashCode ^
      frameDuration.hashCode ^
      part.hashCode ^
      measure.hashCode ^
      tempo.hashCode ^
      keySignature.hashCode ^
      notes.hashCode ^
      chordSymbol.hashCode;

  // ...........................................................................
  final Seconds timePosition;
  final Duration frameDuration;
  final Part part;
  final Measure measure;
  final Tempo tempo;
  final KeySignature keySignature;
  final Iterable<Note> notes;
  final ChordSymbol? chordSymbol;
}

// #############################################################################
final exampleGgSnapshot = GgSnapshot(
  timePosition: 0.0,
  frameDuration: const Duration(milliseconds: 100),
  part: Part('exampleSnapshot0', ScorePart(), []),
  notes: [],
  measure: Measure(number: 0),
  tempo: Tempo(120.0, 0.0),
  keySignature: KeySignature(),
  chordSymbol: null,
);

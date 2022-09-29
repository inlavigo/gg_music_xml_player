// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_snapshot.dart';
import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

void main() {
  final ggSnapShot = exampleGgSnapshot;

  group('GgSnapshotTest', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(ggSnapShot, isNotNull);
      });
    });
  });

  // #########################################################################
  group('copyWith, operator==, hashCode', () {
    test('should create a copy with changed parameters', () {
      final cw = ggSnapShot.copyWith;

      expect(cw() == ggSnapShot, isTrue);
      expect(cw().hashCode == ggSnapShot.hashCode, isTrue);

      // timePosition
      expect(cw(timePosition: 1.0).timePosition, 1.0);
      expect(cw(timePosition: 1.0) == ggSnapShot, isFalse);
      expect(cw(timePosition: 1.0).hashCode == ggSnapShot.hashCode, isFalse);

      // frameDuration
      dynamic x = const Duration(milliseconds: 200);
      expect(cw(frameDuration: x).frameDuration, x);
      expect(cw(frameDuration: x) == ggSnapShot, isFalse);
      expect(cw(frameDuration: x).hashCode == ggSnapShot.hashCode, isFalse);

      // part
      x = Part('id', ScorePart(), []);
      expect(cw(part: x).part, x);
      expect(cw(part: x) == ggSnapShot, isFalse);
      expect(cw(part: x).hashCode == ggSnapShot.hashCode, isFalse);

      // measure
      x = Measure(number: 0);
      expect(cw(measure: x).measure, x);
      expect(cw(measure: x) == ggSnapShot, isFalse);
      expect(cw(measure: x).hashCode == ggSnapShot.hashCode, isFalse);

      // tempo
      x = Tempo(130.0, 1.0);
      expect(cw(tempo: x).tempo, x);
      expect(cw(tempo: x) == ggSnapShot, isFalse);
      expect(cw(tempo: x).hashCode == ggSnapShot.hashCode, isFalse);

      // keySignature
      x = KeySignature();
      expect(cw(keySignature: x).keySignature, x);
      expect(cw(keySignature: x) == ggSnapShot, isFalse);
      expect(cw(keySignature: x).hashCode == ggSnapShot.hashCode, isFalse);

      // voices
      x = <String, Iterable<Note>>{};
      expect(cw(notes: x).notes, x);
      expect(cw(notes: x) == ggSnapShot, isFalse);
      expect(cw(notes: x).hashCode == ggSnapShot.hashCode, isFalse);

      // chordSymbols
      x = ChordSymbol();
      expect(cw(chordSymbol: x).chordSymbol, x);
      expect(cw(chordSymbol: x) == ggSnapShot, isFalse);
      expect(cw(chordSymbol: x).hashCode == ggSnapShot.hashCode, isFalse);
    });
  });
}

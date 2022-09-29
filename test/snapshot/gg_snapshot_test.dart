// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_snapshot.dart';
import 'package:music_xml/music_xml.dart';
import 'package:test/test.dart';

void main() {
  final ggSnapshot = exampleGgSnapshot;

  group('GgSnapshot', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(ggSnapshot, isNotNull);
      });
    });

    // #########################################################################
    group('copyWith, operator==, hashCode', () {
      test('should create a copy with changed parameters', () {
        final cw = ggSnapshot.copyWith;

        expect(cw() == ggSnapshot, isTrue);
        expect(cw().hashCode == ggSnapshot.hashCode, isTrue);

        // timePosition
        expect(cw(timePosition: 1.0).timePosition, 1.0);
        expect(cw(timePosition: 1.0) == ggSnapshot, isFalse);
        expect(cw(timePosition: 1.0).hashCode == ggSnapshot.hashCode, isFalse);

        // part
        dynamic x = Part('id', ScorePart(), []);
        expect(cw(part: x).part, x);
        expect(cw(part: x) == ggSnapshot, isFalse);
        expect(cw(part: x).hashCode == ggSnapshot.hashCode, isFalse);

        // measure
        x = Measure(number: 0);
        expect(cw(measure: x).measure, x);
        expect(cw(measure: x) == ggSnapshot, isFalse);
        expect(cw(measure: x).hashCode == ggSnapshot.hashCode, isFalse);

        // data
        x = 10;
        expect(cw(data: x).data, x);
        expect(cw(data: x) == ggSnapshot, isFalse);
        expect(cw(data: x).hashCode == ggSnapshot.hashCode, isFalse);
      });
    });
  });
}

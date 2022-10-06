// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/timelines/gg_chord_timeline.dart';
import 'package:gg_music_xml_player/src/timelines/gg_note_timeline.dart';
import 'package:gg_music_xml_player/src/timelines/gg_part_timeline.dart';
import 'package:test/test.dart';

void main() {
  final timeline = exampleGgPartTimeline;

  group('GgPartItems', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(timeline.currentItem.validFrom, 0.0);
        expect(timeline.currentItem.validTo, 0.5);
      });
    });

    // #########################################################################
    group('item(timePosition)', () {
      test(
          'should update currentItem and return it. '
          'Should return current item if it is still valid.', () {
        /// Should return the current item as long it is valid
        final item0a = timeline.item(0.0);
        final item0b = timeline.item(item0a.validTo - 0.01);
        expect(item0a.validTo, 0.5);
        expect(item0a.chordItem, isA<GgChordItem>());
        expect(item0a.noteItem, isA<GgNoteItem>());

        expect(item0a, same(item0b));

        /// Should return a new item if a new range has been entered
        final item1a = timeline.item(item0a.validTo);
        expect(item1a, isNot(same(item0a)));
        expect(item1a.validTo, 1.0);

        final item2a = timeline.item(item1a.validTo);
        expect(item2a, isNot(same(item1a)));
        expect(item2a.validTo, 1.5);
      });
    });
  });
}

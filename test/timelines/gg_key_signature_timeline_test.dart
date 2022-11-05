// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/timelines/gg_key_timeline.dart';
import 'package:test/test.dart';

void main() {
  final timeline = exampleGgKeyTimeline;

  group('GgKeySignatureTimeline', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(timeline.items.length, 3);

        final firstItem = timeline.items.first;
        expect(firstItem.data.key, 0);
        expect(firstItem.data.mode, 'major');

        final secondItem = timeline.items[1];
        expect(secondItem.data.key, 2);
        expect(secondItem.data.mode, 'major');

        final thirdItem = timeline.items[2];
        expect(thirdItem.data.key, 4);
        expect(thirdItem.data.mode, 'major');
      });
    });
  });
}

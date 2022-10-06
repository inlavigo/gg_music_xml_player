// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/timelines/gg_key_timeline.dart';
import 'package:test/test.dart';

void main() {
  final timeline = exampleGgKeySignatureTimeline;

  group('GgKeySignatureTimeline', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(timeline.items.length, 1);
        final firstItem = timeline.items.first;
        expect(firstItem.duration, 0.0);
        expect(firstItem.data.key, -1);
        expect(firstItem.data.mode, 'major');
      });
    });
  });
}

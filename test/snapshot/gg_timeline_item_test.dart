// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/timeline/gg_timeline_item.dart';
import 'package:test/test.dart';

void main() {
  const timelineItem = exampleGgTimelineItem;

  group('GgTimelineItem', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(timelineItem, isNotNull);
      });
    });

    // #########################################################################
    group('copyWith, operator==, hashCode', () {
      test('should create a copy with changed parameters', () {
        final cw = timelineItem.copyWith;

        expect(cw() == timelineItem, isTrue);
        expect(cw().hashCode == timelineItem.hashCode, isTrue);

        // validFrom
        expect(cw(validFrom: 1.0).validFrom, 1.0);
        expect(cw(validFrom: 1.0) == timelineItem, isFalse);
        expect(cw(validFrom: 1.0).hashCode == timelineItem.hashCode, isFalse);

        // data
        const x = 10;
        expect(cw(data: x).data, x);
        expect(cw(data: x) == timelineItem, isFalse);
        expect(cw(data: x).hashCode == timelineItem.hashCode, isFalse);
      });
    });
  });
}

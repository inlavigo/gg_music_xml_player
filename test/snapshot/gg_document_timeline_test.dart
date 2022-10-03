// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/timeline/gg_document_timeline.dart';
import 'package:test/test.dart';

void main() {
  final timeline = exampleGgDocumentTimeline;

  group('GgDocumentTimeline', () {
    // #########################################################################
    group('initialization', () {
      test('should create a GgPartItems instance for each part', () {
        final parts = timeline.document.parts;
        final partItems = timeline.currentItem.data;

        expect(partItems.length, parts.length);
        expect(timeline.currentItem.validFrom, 0.0);
        expect(timeline.currentItem.validTo, 0.5);

        var startTime = 0.0;

        for (int i = 0; i < 10; i++) {
          final item = timeline.item(startTime);
          final nextItem = timeline.item(item.validTo);

          expect(item.validFrom, startTime);
          expect(item.validTo, nextItem.validFrom);

          startTime = nextItem.validFrom;
        }
      });
    });
  });
}

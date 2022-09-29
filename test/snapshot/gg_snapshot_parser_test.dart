// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_snapshot_parser.dart';
import 'package:test/test.dart';

void main() {
  final parser = exampleGgSnapshotParser;

  setUp(
    () {
      parser.jumpToBeginning();
    },
  );

  group('GgSnapshotParser', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(parser, isNotNull);
        expect(parser.snapshots.length, 2);
        expect(parser.frameDuration, const Duration(milliseconds: 20));
        expect(parser.snapshot(0.0), parser.snapshots.first);
        expect(parser.part.id, 'P1');
        expect(parser.seed, 0);
      });
    });

    group('jumpToOrBefore, jumpToBeginning', () {
      test('should set current snapshot to the right one', () {
        expect(parser.currentSnapshot, parser.snapshots.first);
        parser.jumpToOrBefore(100);
        expect(parser.currentSnapshot, parser.snapshots.last);
        parser.jumpToOrBefore(0.0);
        expect(parser.currentSnapshot, parser.snapshots.first);
      });
    });

    group('tryToReplaceLastSnapshot', () {
      test('should replace last snapshot if time matches, otherwise not', () {
        expect(parser.currentSnapshot, parser.snapshots.first);
        parser.jumpToOrBefore(100);

        const replacedData = 50;

        // Time does not match -> dont' replace
        var didReplace = parser.tryToReplaceLastSnapshot(
            data: replacedData,
            measure: parser.part.measures.last,
            timePosition: 123890);

        expect(didReplace, isFalse);

        // Time does match -> replace
        didReplace = parser.tryToReplaceLastSnapshot(
          data: 50,
          measure: parser.part.measures.last,
          timePosition: parser.snapshots.last.timePosition,
        );

        expect(didReplace, isTrue);
        expect(parser.snapshots.last.data, replacedData);
      });
    });
  });
}

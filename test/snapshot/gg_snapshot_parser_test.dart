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
        expect(parser.snapshots.length, ExampleSnapshotParser.numSnapshots);
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

    // #########################################################################
    group('futureSnapshots(timePosition, n)', () {
      test('should return n snapshots beginning at timePosition', () {
        const count = 2;
        final futureSnapshots =
            parser.futureSnapshots(timePosition: 0.0, count: count);

        expect(futureSnapshots.first, parser.snapshots.first);
        expect(futureSnapshots.length, count);
      });

      test('should return available snapshots if count is too big', () {
        const count = 10000;
        final futureSnapshots =
            parser.futureSnapshots(timePosition: 0.0, count: count);

        expect(futureSnapshots.first, parser.snapshots.first);
        expect(futureSnapshots.length, parser.snapshots.length);
      });

      test(
          'should return available snapshots if not enough snapshots are available anymore',
          () {
        const count = 5;
        final futureSnapshots = parser.futureSnapshots(
          timePosition: parser.snapshots.last.timePosition,
          count: count,
        );

        expect(futureSnapshots.first, parser.snapshots.last);
        expect(futureSnapshots.length, 1);
      });
    });

    // #########################################################################
    group('pastSnapshots(timePosition, n)', () {
      test('should return n preceeding snapshots beginning at timePosition',
          () {
        const count = 5;
        final referenceSnapshot = parser.snapshots.last;
        final indexOfLastSnapshot = parser.snapshots.length - 1;
        final firstSnapshot = parser.snapshots[indexOfLastSnapshot - count + 1];

        final pastSnapshots = parser.pastSnapshots(
          timePosition: referenceSnapshot.timePosition,
          count: count,
        );

        expect(pastSnapshots, hasLength(count));
        expect(pastSnapshots.first, firstSnapshot);
        expect(pastSnapshots.last, referenceSnapshot);
      });

      test(
          'should return less snapshots if not enough snapshots are available anymore',
          () {
        const count = 5;
        final referenceSnapshot = parser.snapshots.first;
        final firstSnapshot = referenceSnapshot;

        final pastSnapshots = parser.pastSnapshots(
          timePosition: referenceSnapshot.timePosition,
          count: count,
        );

        expect(pastSnapshots, hasLength(1));
        expect(pastSnapshots.first, firstSnapshot);
        expect(pastSnapshots.last, firstSnapshot);
      });
    });
  });
}

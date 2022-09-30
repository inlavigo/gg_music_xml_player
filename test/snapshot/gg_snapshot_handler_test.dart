// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_snapshot_handler.dart';
import 'package:test/test.dart';

void main() {
  final handler = exampleGgSnapshotHandler;

  setUp(
    () {
      handler.jumpToBeginning();
    },
  );

  group('GgSnapshotHandler', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(handler, isNotNull);
        expect(handler.snapshots.length, ExampleSnapshotHandler.numSnapshots);
        expect(handler.snapshot(0.0), handler.snapshots.first);
        expect(handler.part.id, 'P1');
        expect(handler.seed, 0);
      });
    });

    group('jumpToOrBefore, jumpToBeginning', () {
      test('should set current snapshot to the right one', () {
        expect(handler.currentSnapshot, handler.snapshots.first);
        handler.jumpToOrBefore(100);
        expect(handler.currentSnapshot, handler.snapshots.last);
        handler.jumpToOrBefore(0.0);
        expect(handler.currentSnapshot, handler.snapshots.first);
      });
    });

    group('tryToReplaceLastSnapshot', () {
      test('should replace last snapshot if time matches, otherwise not', () {
        expect(handler.currentSnapshot, handler.snapshots.first);
        handler.jumpToOrBefore(100);

        const replacedData = 50;

        // Time does not match -> dont' replace
        var didReplace = handler.tryToReplaceLastSnapshot(
            data: replacedData,
            measure: handler.part.measures.last,
            timePosition: 123890);

        expect(didReplace, isFalse);

        // Time does match -> replace
        didReplace = handler.tryToReplaceLastSnapshot(
          data: 50,
          measure: handler.part.measures.last,
          timePosition: handler.snapshots.last.timePosition,
        );

        expect(didReplace, isTrue);
        expect(handler.snapshots.last.data, replacedData);
      });
    });

    // #########################################################################
    group('futureSnapshots(timePosition, n)', () {
      test('should return n snapshots beginning at timePosition', () {
        const count = 2;
        final futureSnapshots =
            handler.futureSnapshots(timePosition: 0.0, count: count);

        expect(futureSnapshots.first, handler.snapshots.first);
        expect(futureSnapshots.length, count);
      });

      test('should return available snapshots if count is too big', () {
        const count = 10000;
        final futureSnapshots =
            handler.futureSnapshots(timePosition: 0.0, count: count);

        expect(futureSnapshots.first, handler.snapshots.first);
        expect(futureSnapshots.length, handler.snapshots.length);
      });

      test(
          'should return available snapshots if not enough snapshots are available anymore',
          () {
        const count = 5;
        final futureSnapshots = handler.futureSnapshots(
          timePosition: handler.snapshots.last.timePosition,
          count: count,
        );

        expect(futureSnapshots.first, handler.snapshots.last);
        expect(futureSnapshots.length, 1);
      });
    });

    // #########################################################################
    group('pastSnapshots(timePosition, n)', () {
      test('should return n preceeding snapshots beginning at timePosition',
          () {
        const count = 5;
        final referenceSnapshot = handler.snapshots.last;
        final indexOfLastSnapshot = handler.snapshots.length - 1;
        final firstSnapshot =
            handler.snapshots[indexOfLastSnapshot - count + 1];

        final pastSnapshots = handler.pastSnapshots(
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
        final referenceSnapshot = handler.snapshots.first;
        final firstSnapshot = referenceSnapshot;

        final pastSnapshots = handler.pastSnapshots(
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

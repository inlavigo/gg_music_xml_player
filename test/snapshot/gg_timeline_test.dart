// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/timeline/gg_timeline.dart';
import 'package:test/test.dart';

void main() {
  final timeline = exampleGgTimeline;

  setUp(
    () {
      timeline.jumpToBeginning();
    },
  );

  group('GgTimeline', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(timeline, isNotNull);
        expect(timeline.items.length, ExampleTimeline.numItems);
        expect(timeline.item(0.0), timeline.items.first);
        expect(timeline.item(0.0).validFrom, 0.0);
        expect(timeline.item(0.0).validTo, 1.0);
        expect(timeline.item(1.0).validFrom, 1.0);
        expect(timeline.item(1.0).validTo, 2.0);
        expect(timeline.seed, 0);
      });
    });

    group('currentItem, nextItem, jumpToOrBefore, jumpToBeginning', () {
      test('should set current item to the right one', () {
        expect(timeline.currentItem, timeline.items.first);
        expect(timeline.nextItem, timeline.items[1]);
        timeline.jumpToOrBefore(100);
        expect(timeline.currentItem, timeline.items.last);
        expect(timeline.nextItem, timeline.items.last);
        timeline.jumpToOrBefore(0.0);
        expect(timeline.currentItem, timeline.items.first);
        expect(timeline.nextItem, timeline.items[1]);
      });
    });

    group('tryToReplaceLastItem', () {
      test('should replace last item if time matches, otherwise not', () {
        expect(timeline.currentItem, timeline.items.first);
        timeline.jumpToOrBefore(100);

        const replacedData = 50;

        // Time does not match -> dont' replace
        var didReplace = timeline.tryToReplaceLastItem(
          data: replacedData,
          timePosition: 123890,
        );

        expect(didReplace, isFalse);

        // Time does match -> replace
        didReplace = timeline.tryToReplaceLastItem(
          data: 50,
          timePosition: timeline.items.last.validFrom,
        );

        expect(didReplace, isTrue);
        expect(timeline.items.last.data, replacedData);
      });
    });

    // #########################################################################
    group('futureItems(timePosition, n)', () {
      test('should return n items beginning at timePosition', () {
        const count = 2;
        final futureItems =
            timeline.futureItems(timePosition: 0.0, count: count);

        expect(futureItems.first, timeline.items.first);
        expect(futureItems.length, count);
      });

      test('should return available items if count is too big', () {
        const count = 10000;
        final futureItems =
            timeline.futureItems(timePosition: 0.0, count: count);

        expect(futureItems.first, timeline.items.first);
        expect(futureItems.length, timeline.items.length);
      });

      test(
          'should return available items if not enough items are available anymore',
          () {
        const count = 5;
        final futureItems = timeline.futureItems(
          timePosition: timeline.items.last.validFrom,
          count: count,
        );

        expect(futureItems.first, timeline.items.last);
        expect(futureItems.length, 1);
      });
    });

    // #########################################################################
    group('pastItems(timePosition, n)', () {
      test('should return n preceeding items beginning at timePosition', () {
        const count = 5;
        final referenceItem = timeline.items.last;
        final indexOfLastItem = timeline.items.length - 1;
        final firstItem = timeline.items[indexOfLastItem - count + 1];

        final pastItems = timeline.pastItems(
          timePosition: referenceItem.validFrom,
          count: count,
        );

        expect(pastItems, hasLength(count));
        expect(pastItems.first, firstItem);
        expect(pastItems.last, referenceItem);
      });

      test('should return less items if not enough items are available anymore',
          () {
        const count = 5;
        final referenceItem = timeline.items.first;
        final firstItem = referenceItem;

        final pastItems = timeline.pastItems(
          timePosition: referenceItem.validFrom,
          count: count,
        );

        expect(pastItems, hasLength(1));
        expect(pastItems.first, firstItem);
        expect(pastItems.last, firstItem);
      });
    });
  });
}

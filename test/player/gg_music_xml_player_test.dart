// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:fake_async/fake_async.dart';
import 'package:gg_music_xml_player/src/player/gg_music_xml_player_player.dart';
import 'package:gg_music_xml_player/src/timeline/gg_document_timeline.dart';
import 'package:gg_time_controller/gg_time_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FakeStopwatch extends Mock implements Stopwatch {}

void main() {
  late GgMusicXmlPlayer player;
  late GgDocumentItem? currentItem;
  final oneFrame = GgTimeController.defaultFrameDuration.toDuration;
  final stopwatch = FakeStopwatch();
  late FakeAsync fake;

  void onItem(GgDocumentItem item) => currentItem = item;

  void init(FakeAsync fk) {
    fake = fk;
    player = exampleGgMusicXmlPlayer(
      onItem: onItem,
      stopwatch: stopwatch,
    );

    when(() => stopwatch.elapsed).thenAnswer(
      (invocation) {
        return fake.elapsed;
      },
    );

    fake.flushMicrotasks();
  }

  void dispose(FakeAsync fake) {
    fake.flushMicrotasks();
  }

  group('GgMusicXmlPlayer', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        fakeAsync((fake) {
          init(fake);
          expect(player, isNotNull);
          dispose(fake);
        });
      });
    });

    // #########################################################################
    group('onItem', () {
      test('should be called when a item was updated', () {
        fakeAsync(
          (fake) {
            init(fake);

            // Initially no item is delivered
            fake.flushMicrotasks();
            var lastItem = currentItem!;
            var restTime = lastItem.validTo - lastItem.validFrom;
            expect(lastItem.validFrom, 0.0);
            expect(lastItem.validTo, 0.5);
            currentItem = null;

            fake.elapse(const Duration(seconds: 10));
            expect(currentItem, null);

            // Press play
            player.timeController.play();

            // Wait short before end of last item
            restTime = 0.01;
            fake.elapse((lastItem.validTo - restTime).toDuration);
            fake.flushMicrotasks();

            // Snatshot should not have been delivered
            expect(currentItem, isNull);

            // Wait until frame end
            fake.elapse(restTime.toDuration + oneFrame);
            fake.flushMicrotasks();
            expect(currentItem!.validFrom, lastItem.validTo);
            expect(currentItem!.validTo, 1.0);
            lastItem = currentItem!;

            // Press pause
            player.timeController.pause();

            // Wait five seconds
            fake.elapse(const Duration(seconds: 5));
            fake.flushMicrotasks();

            // Current item should not have been changed
            expect(currentItem, lastItem);

            // Press play
            player.timeController.play();

            // Wait to next item
            fake.elapse(currentItem!.duration.toDuration);
            expect(currentItem, isNot(lastItem));
            expect(currentItem?.validFrom, lastItem.validTo);

            dispose(fake);
          },
        );
      });
    });
  });
}

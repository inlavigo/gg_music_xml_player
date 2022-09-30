// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:fake_async/fake_async.dart';
import 'package:gg_music_xml_player/src/player/gg_music_xml_player_player.dart';
import 'package:gg_music_xml_player/src/snapshot/gg_document_snapshots.dart';
import 'package:gg_time_controller/gg_time_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FakeStopwatch extends Mock implements Stopwatch {}

void main() {
  late GgMusicXmlPlayer player;
  late GgDocumentSnapshot? currentSnapshot;
  final oneFrame = GgTimeController.defaultFrameDuration.toDuration;
  final stopwatch = FakeStopwatch();
  late FakeAsync fake;

  void onSnapshot(GgDocumentSnapshot snapshot) => currentSnapshot = snapshot;

  void init(FakeAsync fk) {
    fake = fk;
    player = exampleGgMusicXmlPlayer(
      onSnapshot: onSnapshot,
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
    group('onSnapshot', () {
      test('should be called when a snapshot was updated', () {
        fakeAsync(
          (fake) {
            init(fake);

            // Initially no snapshot is delivered
            fake.flushMicrotasks();
            var lastSnapshot = currentSnapshot!;
            var restTime = lastSnapshot.validTo - lastSnapshot.validFrom;
            expect(lastSnapshot.validFrom, 0.0);
            expect(lastSnapshot.validTo, 0.5);
            currentSnapshot = null;

            fake.elapse(const Duration(seconds: 10));
            expect(currentSnapshot, null);

            // Press play
            player.timeController.play();

            // Wait short before end of last snapshot
            restTime = 0.01;
            fake.elapse((lastSnapshot.validTo - restTime).toDuration);
            fake.flushMicrotasks();

            // Snatshot should not have been delivered
            expect(currentSnapshot, isNull);

            // Wait until frame end
            fake.elapse(restTime.toDuration + oneFrame);
            fake.flushMicrotasks();
            expect(currentSnapshot!.validFrom, lastSnapshot.validTo);
            expect(currentSnapshot!.validTo, 1.0);
            lastSnapshot = currentSnapshot!;

            // Press pause
            player.timeController.pause();

            // Wait five seconds
            fake.elapse(const Duration(seconds: 5));
            fake.flushMicrotasks();

            // Current snapshot should not have been changed
            expect(currentSnapshot, lastSnapshot);

            // Press play
            player.timeController.play();

            // Wait to next snapshot
            fake.elapse(currentSnapshot!.duration.toDuration);
            expect(currentSnapshot, isNot(lastSnapshot));
            expect(currentSnapshot?.validFrom, lastSnapshot.validTo);

            dispose(fake);
          },
        );
      });
    });
  });
}

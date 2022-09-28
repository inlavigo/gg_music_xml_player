// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/gg_snapshot_calculator.dart';
import 'package:test/test.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  late GgSnapshotCalculator ggSnapshotGenerator = exampleGgSnapshotGenerator();

  group('GgSnapshotGenerator', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        fakeAsync((fake) {
          expect(ggSnapshotGenerator, isNotNull);
        });
      });
    });

    // #########################################################################
    group('snapshot(time)', () {
      test('should return the right snapshot for the given time', () {
        // At the beginning, the snapshot should have no notes
        // but the right time and key signature and the right tempo
        final snapshot = ggSnapshotGenerator.snapshot(timePosition: 0.0);
        print(snapshot);

        // expect(snapshot.keySignature.key, -2);
        // expect(snapshot.keySignature.mode, -2);
        // expect(snapshot.keySignature.timePosition, 0.0);
      });
    });
  });
}

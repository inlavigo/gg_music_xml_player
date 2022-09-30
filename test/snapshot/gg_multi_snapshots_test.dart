// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_multi_snapshots.dart';
import 'package:test/test.dart';

void main() {
  final multiSnapshots = exampleGgMultiSnapshots;

  group('GgMultiSnapshots', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(multiSnapshots.currentSnapshot.validFrom, 0.0);
        expect(multiSnapshots.currentSnapshot.validTo, 0.5);
      });
    });

    // #########################################################################
    group('snapshot(timePosition)', () {
      test(
          'should update currentSnapshot and return it. '
          'Should return current snapshot if it is still valid.', () {
        /// Should return the current snapshot as long it is valid
        final snapshot0a = multiSnapshots.snapshot(0.0);
        final snapshot0b = multiSnapshots.snapshot(snapshot0a.validTo - 0.01);
        expect(snapshot0a.validTo, 0.5);

        expect(snapshot0a, same(snapshot0b));

        /// Should return a new snapshot if a new range has been entered
        final snapshot1a = multiSnapshots.snapshot(snapshot0a.validTo);
        expect(snapshot1a, isNot(same(snapshot0a)));
        expect(snapshot1a.validTo, 1.0);
      });
    });
  });
}

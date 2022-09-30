// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_chord_snapshots.dart';
import 'package:gg_music_xml_player/src/snapshot/typedefs.dart';
import 'package:test/test.dart';

void main() {
  final ggChordSnapshots = exampleGgChordSnapshots;

  group('GgChordSnapshots', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(ggChordSnapshots, isNotNull);
        expect(ggChordSnapshots.snapshots, hasLength(12));
        const kickOff = 0.5;

        final snapshot0 = ggChordSnapshots.snapshots[0];
        expect(snapshot0.data.root, 'F');
        expect(snapshot0.validFrom, 0.0);

        Seconds bar(int bar) {
          return kickOff + bar * 2;
        }

        final snapshotBar1 = ggChordSnapshots.snapshot(bar(1));
        expect(snapshotBar1.data.root, 'F');
        expect(snapshotBar1.validFrom, bar(0));

        final snapshotBar2 = ggChordSnapshots.snapshot(bar(2));
        expect(snapshotBar2.data.root, 'C');
        expect(snapshotBar2.validFrom, bar(2));

        final snapshotBar3 = ggChordSnapshots.snapshot(bar(3));
        expect(snapshotBar3.data.root, 'F');
        expect(snapshotBar3.validFrom, bar(3));

        final snapshotBar5 = ggChordSnapshots.snapshot(bar(5));
        expect(snapshotBar5.data.root, 'F');
        expect(snapshotBar5.validFrom, bar(3));
      });
    });
  });
}

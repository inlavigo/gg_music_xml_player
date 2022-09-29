// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_note_snapshot_calculator.dart';
import 'package:test/test.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  late GgNoteSnapshotCalculator ggSnapshotGenerator =
      exampleGgSnapshotGenerator();

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
        final snapshots = ggSnapshotGenerator.snapshots;

        var snapshot = snapshots.first;
        expect(snapshot.timePosition, 0.0);
        expect(snapshot.keySignature.key, -1);
        expect(snapshot.keySignature.mode, 'major');
        expect(snapshot.notes, [snapshot.part.measures[0].notes[0]]);

        // Bar 2
        expect(snapshots[1].notes, [snapshot.part.measures[1].notes[0]]);
        expect(snapshots[2].notes, [snapshot.part.measures[1].notes[1]]);
        expect(snapshots[3].notes, [snapshot.part.measures[1].notes[2]]);
        expect(snapshots[4].notes, [snapshot.part.measures[1].notes[3]]);

        // Last bar
        expect(snapshots[snapshots.length - 2].notes.last,
            snapshot.part.measures.last.notes.last);
      });
    });
  });
}

// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/sample_xml/tie/tie_xml.dart';
import 'package:gg_music_xml_player/src/snapshot/gg_note_snapshots.dart';
import 'package:gg_music_xml_player/src/snapshot/gg_combined_snapshot.dart';
import 'package:test/test.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  late GgNoteSnapshots ggNoteSnapshots = exampleNoteSnapshots();

  group('GgSnapshotGenerator', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        fakeAsync((fake) {
          // Get all snapshots
          final snapshots = ggNoteSnapshots.snapshots;

          // Check key signature
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

      test('should load ties correctly', () {
        final snapshotGenerator = GgNoteSnapshots(part: tieXmlDoc.parts.first);
        expect(snapshotGenerator.snapshots.length, 4);

        // The tied duration of the notes should span three measures
        final firstNote = snapshotGenerator.snapshots.first.notes.first;
        expect(firstNote.noteDuration.seconds, 2);
        expect(firstNote.noteDuration.timePosition, 0);
        expect(firstNote.noteDurationTied.timePosition, 0);
        expect(firstNote.noteDurationTied.seconds, 6);

        // The tied duration of the notes should span three measures
        final secondNote = snapshotGenerator.snapshots[1].notes.first;
        expect(secondNote.noteDuration.seconds, 2);
        expect(secondNote.noteDuration.timePosition, 2);
        expect(secondNote.noteDurationTied.timePosition, 0);
        expect(secondNote.noteDurationTied.seconds, 6);

        // The tied duration of the notes should span three measures
        final thirdNote = snapshotGenerator.snapshots[2].notes.first;
        expect(thirdNote.noteDuration.seconds, 2);
        expect(thirdNote.noteDuration.timePosition, 4);
        expect(thirdNote.noteDurationTied.timePosition, 0);
        expect(thirdNote.noteDurationTied.seconds, 6);
      });
    });

    // #########################################################################
    group('snapshot(time)', () {
      test('should return the right snapshot for the given time', () {
        final snapshots = ggNoteSnapshots.snapshots;

        // Check exact positions of snapshots
        void checkTimePosition(GgCombinedSnapshot snapshot) {
          expect(
            snapshot,
            ggNoteSnapshots.snapshot(
              timePosition: snapshot.timePosition,
            ),
          );
        }

        checkTimePosition(snapshots[0]);
        checkTimePosition(snapshots[5]);
        checkTimePosition(snapshots[1]);
        checkTimePosition(snapshots.last);

        // Check positions inbetween snapshots
        final t0 = snapshots[0].timePosition;
        final t1 = snapshots[1].timePosition;
        final t01 = t0 + (t1 - t0) / 2;
        expect(ggNoteSnapshots.snapshot(timePosition: t01), snapshots[0]);
      });
    });
  });
}

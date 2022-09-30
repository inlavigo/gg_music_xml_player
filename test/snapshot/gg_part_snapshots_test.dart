// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_chord_snapshots.dart';
import 'package:gg_music_xml_player/src/snapshot/gg_note_snapshots.dart';
import 'package:gg_music_xml_player/src/snapshot/gg_part_snapshots.dart';
import 'package:test/test.dart';

void main() {
  final partSnapshots = exampleGgPartSnapshots;

  group('GgPartSnapshots', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(partSnapshots.currentSnapshot.validFrom, 0.0);
        expect(partSnapshots.currentSnapshot.validTo, 0.5);
      });
    });

    // #########################################################################
    group('snapshot(timePosition)', () {
      test(
          'should update currentSnapshot and return it. '
          'Should return current snapshot if it is still valid.', () {
        /// Should return the current snapshot as long it is valid
        final snapshot0a = partSnapshots.snapshot(0.0);
        final snapshot0b = partSnapshots.snapshot(snapshot0a.validTo - 0.01);
        expect(snapshot0a.validTo, 0.5);
        expect(snapshot0a.chordSnapshot, isA<GgChordSnapshot>());
        expect(snapshot0a.noteSnapshot, isA<GgNoteSnapshot>());

        expect(snapshot0a, same(snapshot0b));

        /// Should return a new snapshot if a new range has been entered
        final snapshot1a = partSnapshots.snapshot(snapshot0a.validTo);
        expect(snapshot1a, isNot(same(snapshot0a)));
        expect(snapshot1a.validTo, 1.0);

        final snapshot2a = partSnapshots.snapshot(snapshot1a.validTo);
        expect(snapshot2a, isNot(same(snapshot1a)));
        expect(snapshot2a.validTo, 1.5);
      });
    });
  });
}

// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_document_snapshots.dart';
import 'package:test/test.dart';

void main() {
  final s = exampleGgDocumentSnapshots;

  group('GgDocumentSnapshots', () {
    // #########################################################################
    group('initialization', () {
      test('should create a GgPartSnapshots instance for each part', () {
        final parts = s.document.parts;
        final partSnapshots = s.currentSnapshot.data;

        expect(partSnapshots.length, parts.length);
        expect(s.currentSnapshot.validFrom, 0.0);
        expect(s.currentSnapshot.validTo, 0.5);

        var startTime = 0.0;

        for (int i = 0; i < 10; i++) {
          final snapshot = s.snapshot(startTime);
          final nextSnapshot = s.snapshot(snapshot.validTo);

          expect(snapshot.validFrom, startTime);
          expect(snapshot.validTo, nextSnapshot.validFrom);

          startTime = nextSnapshot.validFrom;
        }
      });
    });
  });
}

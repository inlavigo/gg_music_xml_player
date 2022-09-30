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
        final ps = s.currentSnapshot.data;
        expect(ps.length, parts.length);
        expect(ps.first.data.data.id, parts.first.id);
        expect(ps.last.data.id, parts.last.id);
        expect(s.currentSnapshot.validFrom, 0.0);
        expect(s.currentSnapshot.validTo, 0.5);
      });
    });
  });
}

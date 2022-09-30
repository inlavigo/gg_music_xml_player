// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_document_snapshots.dart';
import 'package:test/test.dart';

void main() {
  final documentSnapshots = exampleGgDocumentSnapshots;

  group('GgDocumentSnapshots', () {
    // #########################################################################
    group('initialization', () {
      test('should create a GgPartSnapshots instance for each part', () {
        final partSnapshots = documentSnapshots.partSnapshots;
        expect(partSnapshots.length, documentSnapshots.document.parts.length);
        expect(partSnapshots.first.part.id,
            documentSnapshots.document.parts.first.id);
        expect(partSnapshots.last.part.id,
            documentSnapshots.document.parts.last.id);
      });
    });
  });
}

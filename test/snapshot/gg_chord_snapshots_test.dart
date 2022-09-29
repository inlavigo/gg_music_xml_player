// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_chord_snapshots.dart';
import 'package:test/test.dart';

void main() {
  final ggChordSnapshots = exampleGgChordSnapshots;

  group('GgChordSnapshots', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(ggChordSnapshots, isNotNull);
      });
    });
  });
}

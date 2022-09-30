// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/snapshot/gg_part_snapshots.dart';
import 'package:test/test.dart';

void main() {
  final partSnapshot = exampleGgPartSnapshots;

  group('GgPartSnapshots', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        expect(partSnapshot, isNotNull);
      });
    });
  });
}

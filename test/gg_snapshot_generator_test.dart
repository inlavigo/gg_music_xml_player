// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/gg_snapshot_generator.dart';
import 'package:test/test.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  late GgSnapshotGenerator ggSnapshotGenerator;

  void init(FakeAsync fake) {
    ggSnapshotGenerator = exampleGgSnapshotGenerator();
    fake.flushMicrotasks();
  }

  void dispose(FakeAsync fake) {
    ggSnapshotGenerator.dispose();
    fake.flushMicrotasks();
  }

  group('GgSnapshotGenerator', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        fakeAsync((fake) {
          init(fake);
          expect(ggSnapshotGenerator, isNotNull);
          dispose(fake);
        });
      });
    });
  });
}

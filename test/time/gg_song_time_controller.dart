// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:fake_async/fake_async.dart';
import 'package:gg_music_xml_player/src/time/gg_song_time_controller.dart';
import 'package:test/test.dart';

void main() {
  late GgSongTimeController ggSongTimeController;

  void init(FakeAsync fake) {
    ggSongTimeController = exampleGgSongTimeController();
    fake.flushMicrotasks();
  }

  void dispose(FakeAsync fake) {
    ggSongTimeController.dispose();
    fake.flushMicrotasks();
  }

  group('GgSongTimeController', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        fakeAsync((fake) {
          init(fake);
          expect(ggSongTimeController, isNotNull);
          dispose(fake);
        });
      });
    });
  });
}

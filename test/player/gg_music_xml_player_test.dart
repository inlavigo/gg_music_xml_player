// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:fake_async/fake_async.dart';
import 'package:gg_music_xml_player/src/player/gg_music_xml_player_player.dart';
import 'package:test/test.dart';

void main() {
  late GgMusicXmlPlayer ggMusicXmlPlayer;

  void init(FakeAsync fake) {
    ggMusicXmlPlayer = exampleGgMusicXmlPlayer();
    fake.flushMicrotasks();
  }

  void dispose(FakeAsync fake) {
    ggMusicXmlPlayer.dispose();
    fake.flushMicrotasks();
  }

  group('GgMusicXmlPlayer', () {
    // #########################################################################
    group('initialization', () {
      test('should work fine', () {
        fakeAsync((fake) {
          init(fake);
          expect(ggMusicXmlPlayer, isNotNull);
          dispose(fake);
        });
      });
    });
  });
}

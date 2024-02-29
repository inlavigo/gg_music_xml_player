// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/time/gg_song_time_controller.dart';
import 'package:gg_time_controller/gg_time_controller.dart';
import 'package:test/test.dart';

void main() {
  group('GgSongTimeController', () {
    group('should work fine', () {
      test('without time controller', () {
        final controller = exampleGgSongTimeController();
        expect(controller, isNotNull);
        controller.play();
        controller.pause();
        controller.stop();
        controller.jumpToMeasure();
        controller.animateToMeasure();
        controller.dispose();
        controller.timeController.onTimeStamp(0.05);
      });

      test('with time controller', () {
        final timeController = exampleTimeController();
        final controller = exampleGgSongTimeController(
          timeController: timeController,
        );
        timeController.onTimeStamp(0.05);

        expect(controller, isNotNull);
      });
    });
  });
}

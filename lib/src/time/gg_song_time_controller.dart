// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_time_controller/gg_time_controller.dart';
import 'package:music_xml/music_xml.dart';

import '../example/gg_example_xml.dart';

/// Takes music xml  and yields past, current and future notes for a given time.
class GgSongTimeController {
  GgSongTimeController({
    required this.musicXmlDocument,
    GgTimeController? timeController,
  }) {
    _init();
    _initTimeController(timeController);
  }

  // ...........................................................................
  void dispose() {
    for (final d in _dispose.reversed) {
      d();
    }
  }

  // ...........................................................................
  final MusicXmlDocument musicXmlDocument;
  late GgTimeController timeController;

  // ...........................................................................
  void play() {}
  void pause() {}
  void stop() {}
  void jumpToMeasure() {}
  void animateToMeasure() {}

  // ######################
  // Private
  // ######################

  final List<Function()> _dispose = [];
  void _init() {
    _dispose.add(() {});
  }

  // ...........................................................................
  void _initTimeController(GgTimeController? tc) {
    if (tc != null) {
      timeController = tc;
      return;
    }

    timeController = tc ??
        GgTimeController(
          onTimeStamp: (p0) {},
        );

    _dispose.add(timeController.dispose);
  }
}

// #############################################################################
GgSongTimeController exampleGgSongTimeController({
  MusicXmlDocument? document,
}) =>
    GgSongTimeController(
      musicXmlDocument: document ?? exampleMusicXmlDocument,
    );

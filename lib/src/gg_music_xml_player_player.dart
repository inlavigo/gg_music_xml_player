// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

class GgMusicXmlPlayer {
  GgMusicXmlPlayer() {
    _init();
  }

  // ...........................................................................
  void dispose() {
    for (final d in _dispose.reversed) {
      d();
    }
  }

  // ######################
  // Private
  // ######################

  final List<Function()> _dispose = [];
  void _init() {
    _dispose.add(() {});
  }
}

// #############################################################################
GgMusicXmlPlayer exampleGgMusicXmlPlayer() => GgMusicXmlPlayer();

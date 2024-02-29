// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_music_xml_player/src/sample_xml/tied_note/gg_example_music_xml_tied_note.dart';
import 'package:test/test.dart';

void main() {
  group('GgExampleMusicXmlTiedNote', () {
    test('should work fine', () {
      // const GgExampleMusicXmlTiedNote();
      expect(ggExampleMusicXmlTiedNoteString, isNotNull);
      expect(ggExampleMusicXmlTiedNote, isNotNull);
    });
  });
}

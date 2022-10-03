// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_timeline/gg_timeline.dart';
import 'package:gg_typedefs/gg_typedefs.dart';
import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_chord_timeline.dart';
import 'gg_note_timeline.dart';

typedef GgPartItemData = Iterable<GgTimelineItem<dynamic>>;
typedef GgPartItem = GgTimelineItem<GgPartItemData>;

extension GgPartItemDataExtension on GgPartItem {
  GgChordItem get chordItem => data.elementAt(0) as GgChordItem;

  GgNoteItem get noteItem => data.elementAt(1) as GgNoteItem;
}

// #############################################################################
/// Manages all items for a given part
class GgPartItems extends GgTimeline<GgPartItemData> {
  GgPartItems({
    required this.part,
  })  : chordItems = GgChordTimeline(part: part),
        noteItems = GgNoteItems(part: part) {
    _init();
  }

  // ...........................................................................
  final Part part;

  // ...........................................................................
  late Iterable<GgTimeline> itemHandlers;

  // ...........................................................................
  final GgChordTimeline chordItems;
  final GgNoteItems noteItems;

  // ...........................................................................
  @override
  GgPartItemData get seed => [
        chordItems.currentItem,
        noteItems.currentItem,
      ];

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init() {
    itemHandlers = [chordItems, noteItems];
    _initItems();
    jumpToOrBefore(0.0);
  }

  // ...........................................................................
  void _initItems() {
    List<GgSeconds> times = [];

    // Collect all times where something changes
    for (final handler in itemHandlers) {
      for (final item in handler.items) {
        times.add(item.validFrom);
      }
    }

    // Sort times
    times.sort(
      (a, b) => a.compareTo(b),
    );

    // For each time create a item
    for (int i = 0; i < times.length; i++) {
      final validFrom = times[i];
      final data = <GgTimelineItem>[];

      for (final handler in itemHandlers) {
        handler.jumpToOrBefore(validFrom);
        data.add(handler.currentItem);
      }

      addOrReplaceItem(data: data, timePosition: validFrom);
    }
  }
}

// #############################################################################
final exampleGgPartTimeline = GgPartItems(
  part: wholePieceXmlDoc.parts.first,
);

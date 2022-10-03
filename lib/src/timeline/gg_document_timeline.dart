// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_timeline/gg_timeline.dart';
import 'package:gg_typedefs/gg_typedefs.dart';
import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_part_timeline.dart';

// #############################################################################
typedef GgDocumentItemData = List<GgPartItem>;
typedef GgDocumentItem = GgTimelineItem<GgDocumentItemData>;

// #############################################################################
class GgDocumentTimeline extends GgTimeline<GgDocumentItemData> {
  GgDocumentTimeline({
    required this.document,
  }) {
    _init();
  }

  // ...........................................................................
  final MusicXmlDocument document;

  // ...........................................................................
  late Iterable<GgPartItems> itemHandlers;

  // ...........................................................................
  @override
  GgDocumentItemData get seed => [];

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init() {
    itemHandlers = document.parts.map(
      (e) => GgPartItems(part: e),
    );
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
      final GgDocumentItemData data = [];

      for (final handler in itemHandlers) {
        handler.jumpToOrBefore(validFrom);
        data.add(handler.currentItem);
      }

      addOrReplaceItem(data: data, timePosition: validFrom);
    }
  }
}

// #############################################################################
final exampleGgDocumentTimeline = GgDocumentTimeline(
  document: wholePieceXmlDoc,
);

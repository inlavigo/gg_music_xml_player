// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import 'typedefs.dart';

/// Defines a snapshot of music xml data for a given time position
class GgSnapshot<T> {
  const GgSnapshot({
    required this.timePosition,
    required this.part,
    required this.measure,
    required this.data,
  });

  final Seconds timePosition;
  final Part part;
  final Measure measure;
  final T data;
}

// #############################################################################
final exampleGgSnapshot = GgSnapshot<int>(
  timePosition: 0.0,
  part: Part('exampleSnapshot0', ScorePart(), []),
  measure: Measure(number: 0),
  data: 0,
);

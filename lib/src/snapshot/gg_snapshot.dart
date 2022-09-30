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
    required this.validFrom,
    required this.validTo,
    required this.data,
  });

  final Seconds validFrom;
  final Seconds validTo;
  final T data;

  Seconds get duration => validTo - validFrom;

  // ...........................................................................
  GgSnapshot<T> copyWith({
    Seconds? validFrom,
    Seconds? validTo,
    Part? part,
    Measure? measure,
    T? data,
  }) {
    return GgSnapshot(
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      data: data ?? this.data,
    );
  }

  // ...........................................................................
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            (other is GgSnapshot) &&
            (other.validFrom == validFrom) &&
            (other.validTo == validTo) &&
            (other.data == data));
  }

  // ...........................................................................
  @override
  int get hashCode => validFrom.hashCode ^ validTo.hashCode ^ data.hashCode;
}

// #############################################################################
const exampleGgSnapshot = GgSnapshot<int>(
  validFrom: 0.0,
  validTo: 0.0,
  data: 0,
);

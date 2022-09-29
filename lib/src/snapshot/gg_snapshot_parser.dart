// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import 'gg_snapshot.dart';
import 'typedefs.dart';

// #############################################################################
abstract class GgSnapshotParser<T> {
  GgSnapshotParser({
    required this.part,
    this.frameDuration = const Duration(milliseconds: 20),
  }) {
    _init();
  }

  // ...........................................................................
  final Part part;
  final Duration frameDuration;

  /// Returns the initial snapshot
  T get seed;

  /// Returns all snapshots
  List<GgSnapshot<T>> get snapshots => _snapshots;

  // ...........................................................................
  /// Returns the snapshot for a given time
  GgSnapshot<T> snapshot(Seconds timePosition) {
    jumpToOrBefore(timePosition);
    return _currentSnapshot;
  }

  // ######################
  // Protected
  // ######################

  // ...........................................................................
  void jumpToBeginning() {
    _currentSnapshot = snapshots.first;
    _indexOfCurrentSnapshot = 0;
  }

  // ...........................................................................
  void jumpToOrBefore(Seconds timePosition) {
    if (_currentSnapshot.timePosition == timePosition) {
      return;
    }

    final startIndex = _indexOfCurrentSnapshot;

    // Find or snapshot in future
    var index = startIndex;
    if (timePosition > _currentSnapshot.timePosition) {
      while (++index < snapshots.length) {
        final snapShot = snapshots[index];
        if (snapShot.timePosition > timePosition) {
          break;
        }
        _indexOfCurrentSnapshot = index;
        _currentSnapshot = snapShot;
      }
    }

    // Find snapshot in past
    else {
      while (--index >= 0) {
        final snapShot = snapshots[index];
        _indexOfCurrentSnapshot = index;
        _currentSnapshot = snapShot;

        if (snapShot.timePosition <= timePosition) {
          break;
        }
      }
    }
  }

  // ...........................................................................
  GgSnapshot<T> get currentSnapshot => _currentSnapshot;

  // ...........................................................................
  bool tryToReplaceLastSnapshot({
    required T data,
    required Seconds timePosition,
    required Measure measure,
  }) {
    if (timePosition == _currentSnapshot.timePosition) {
      _currentSnapshot = createSnapshot(
        data: data,
        timePosition: timePosition,
        measure: measure,
      );

      _snapshots[_indexOfCurrentSnapshot] = _currentSnapshot;
      return true;
    }

    return false;
  }

  // ...........................................................................
  void addOrReplaceSnapshot({
    required T data,
    required Seconds timePosition,
    required Measure measure,
  }) {
    final snapshot = GgSnapshot<T>(
      data: data,
      measure: measure,
      part: part,
      timePosition: timePosition,
    );

    jumpToOrBefore(snapshot.timePosition);

    // Just replace last snapshot when possible
    if (tryToReplaceLastSnapshot(
      data: data,
      timePosition: timePosition,
      measure: measure,
    )) {
      return;
    }

    final newSnapshot = createSnapshot(
      data: data,
      timePosition: timePosition,
      measure: measure,
    );

    _snapshots.insert(_indexOfCurrentSnapshot + 1, newSnapshot);
  }

  // ...........................................................................
  GgSnapshot<T> createSnapshot({
    required T data,
    required Seconds timePosition,
    required Measure measure,
  }) =>
      GgSnapshot<T>(
        timePosition: timePosition,
        data: data,
        part: part,
        measure: measure,
      );

  // ######################
  // Private
  // ######################

  // ...........................................................................
  final _snapshots = <GgSnapshot<T>>[];
  var _indexOfCurrentSnapshot = 0;
  late GgSnapshot<T> _currentSnapshot;

  // ...........................................................................
  void _init() {
    _initInitialSnapshot();
  }

  // ...........................................................................
  void _initInitialSnapshot() {
    _currentSnapshot = createSnapshot(
      data: seed,
      timePosition: 0.0,
      measure: part.measures.first,
    );

    _indexOfCurrentSnapshot = 0;
    _snapshots.add(_currentSnapshot);
  }
}

// #############################################################################
class ExampleSnapshotParser extends GgSnapshotParser<int> {
  ExampleSnapshotParser({
    required super.part,
  }) {
    _addSecondSnapshot();
  }

  // ...........................................................................
  @override
  int get seed => 0;

  // ...........................................................................
  void _addSecondSnapshot() {
    addOrReplaceSnapshot(
      data: 2,
      timePosition: 2,
      measure: part.measures.first,
    );
  }
}

final exampleGgSnapshotParser = ExampleSnapshotParser(
  part: wholePieceXmlDoc.parts.first,
);

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
abstract class GgSnapshotHandler<T> {
  GgSnapshotHandler({
    required this.part,
  }) {
    _init();
  }

  // ...........................................................................
  final Part part;

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

  // ...........................................................................
  /// Returns n future snapshots starting at the given time position.
  Iterable<GgSnapshot<T>> futureSnapshots({
    required Seconds timePosition,
    required int count,
  }) {
    jumpToOrBefore(timePosition);

    bool hasEnoughSnapshots =
        _indexOfCurrentSnapshot + count <= _snapshots.length;

    final endIndex =
        hasEnoughSnapshots ? _indexOfCurrentSnapshot + count : null;

    return _snapshots.sublist(_indexOfCurrentSnapshot, endIndex);
  }

  // ...........................................................................
  /// Returns n past snapshots starting at the given time position.
  Iterable<GgSnapshot<T>> pastSnapshots({
    required Seconds timePosition,
    required int count,
  }) {
    jumpToOrBefore(timePosition);

    bool hasEnoughSnapshots = _indexOfCurrentSnapshot >= count - 1;
    final startIndex =
        hasEnoughSnapshots ? _indexOfCurrentSnapshot - count + 1 : 0;
    final endIndex = _indexOfCurrentSnapshot;

    return _snapshots.sublist(startIndex, endIndex + 1);
  }

  // ######################
  // Protected
  // ######################

  // ...........................................................................
  void jumpToBeginning() {
    _currentSnapshot = snapshots.first;
    _nextSnapshot = snapshots.length > 1 ? snapshots[1] : _currentSnapshot;
    _indexOfCurrentSnapshot = 0;
  }

  // ...........................................................................
  void jumpToOrBefore(Seconds timePosition) {
    if (timePosition >= _currentSnapshot.timePosition &&
        timePosition < _nextSnapshot.timePosition) {
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
  /// Returns the current snapshot
  GgSnapshot<T> get currentSnapshot => _currentSnapshot;

  // ...........................................................................
  /// Returns the next snapshot.
  /// Returns the last snapshot when no following snapshot is available
  GgSnapshot<T> get nextSnapshot =>
      _indexOfCurrentSnapshot == _snapshots.length - 1
          ? _currentSnapshot
          : _snapshots[_indexOfCurrentSnapshot + 1];

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
  late GgSnapshot<T> _nextSnapshot;

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

    _nextSnapshot = _currentSnapshot;

    _indexOfCurrentSnapshot = 0;
    _snapshots.add(_currentSnapshot);
  }
}

// #############################################################################
class ExampleSnapshotHandler extends GgSnapshotHandler<int> {
  ExampleSnapshotHandler({
    required super.part,
  }) {
    _addFurtherSnapshots();
  }

  // ...........................................................................
  @override
  int get seed => 0;

  static const int numSnapshots = 20;

  // ...........................................................................
  void _addFurtherSnapshots() {
    for (int i = 0; i < numSnapshots; i++) {
      addOrReplaceSnapshot(
        data: i,
        timePosition: i.toDouble(),
        measure: part.measures.first,
      );
    }
  }
}

final exampleGgSnapshotHandler = ExampleSnapshotHandler(
  part: wholePieceXmlDoc.parts.first,
);

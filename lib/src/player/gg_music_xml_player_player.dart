// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_time_controller/gg_time_controller.dart';
import 'package:music_xml/music_xml.dart';

import '../sample_xml/whole_piece/gg_whole_piece_xml.dart';
import '../snapshot/gg_document_snapshots.dart';
import '../snapshot/typedefs.dart';

typedef OnDocSnapshot = void Function(GgDocumentSnapshot snapshots);

class GgMusicXmlPlayer {
  GgMusicXmlPlayer({
    required this.document,
    required this.onSnapshot,
    double? frameRate,
    Stopwatch? stopwatch,
    GgPeriodicTimer? timer,
  }) {
    _init(
      frameRate: frameRate,
      stopwatch: stopwatch,
      timer: timer,
    );
  }

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _init({
    required double? frameRate,
    required Stopwatch? stopwatch,
    required GgPeriodicTimer? timer,
  }) {
    _initDocument();
    _initTimeController(
      frameRate: frameRate,
      stopwatch: stopwatch,
      timer: timer,
    );
  }

  // ...........................................................................
  late GgTimeController timeController;

  // ...........................................................................
  void _initTimeController({
    required double? frameRate,
    required Stopwatch? stopwatch,
    required GgPeriodicTimer? timer,
  }) {
    timeController = GgTimeController(
      onTimeStamp: _timerFired,
      frameRate: frameRate ?? GgTimeController.defaultFrameRate,
      stopwatch: stopwatch,
      timer: timer,
    );
  }

  // ...........................................................................
  final MusicXmlDocument document;
  late GgDocumentSnapshots snapshots;
  final OnDocSnapshot onSnapshot;

  // ######################
  // Private
  // ######################

  void _initDocument() {
    snapshots = GgDocumentSnapshots(document: document);
    onSnapshot(snapshots.currentSnapshot);
  }

  // ...........................................................................
  void _timerFired(Seconds time) {
    final nothingHasChanged = time >= snapshots.currentSnapshot.validFrom &&
        time < snapshots.currentSnapshot.validTo;
    if (nothingHasChanged) {
      return;
    }

    final newSnapshot = snapshots.snapshot(time);
    onSnapshot(newSnapshot);
  }
}

// #############################################################################
GgMusicXmlPlayer exampleGgMusicXmlPlayer({
  OnDocSnapshot? onSnapshot,
  Stopwatch? stopwatch,
}) =>
    GgMusicXmlPlayer(
        document: wholePieceXmlDoc,
        onSnapshot: onSnapshot ?? (_) {},
        stopwatch: stopwatch ?? Stopwatch());

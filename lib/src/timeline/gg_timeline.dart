// @license
// Copyright (c) 2019 - 2022 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'gg_timeline_item.dart';
import 'typedefs.dart';

// #############################################################################
abstract class GgTimeline<T> {
  GgTimeline() {
    _init();
  }

  /// Returns the initial item
  T get seed;

  /// Returns all items
  List<GgTimelineItem<T>> get items => _timeline;

  // ...........................................................................
  /// Returns the item for a given time
  GgTimelineItem<T> item(Seconds timePosition) {
    jumpToOrBefore(timePosition);
    return _currentItem;
  }

  // ...........................................................................
  /// Returns n future items starting at the given time position.
  Iterable<GgTimelineItem<T>> futureItems({
    required Seconds timePosition,
    required int count,
  }) {
    jumpToOrBefore(timePosition);

    bool hasEnoughItems = _indexOfCurrentItem + count <= _timeline.length;

    final endIndex = hasEnoughItems ? _indexOfCurrentItem + count : null;

    return _timeline.sublist(_indexOfCurrentItem, endIndex);
  }

  // ...........................................................................
  /// Returns n past items starting at the given time position.
  Iterable<GgTimelineItem<T>> pastItems({
    required Seconds timePosition,
    required int count,
  }) {
    jumpToOrBefore(timePosition);

    bool hasEnoughItems = _indexOfCurrentItem >= count - 1;
    final startIndex = hasEnoughItems ? _indexOfCurrentItem - count + 1 : 0;
    final endIndex = _indexOfCurrentItem;

    return _timeline.sublist(startIndex, endIndex + 1);
  }

  // ######################
  // Protected
  // ######################

  // ...........................................................................
  void jumpToBeginning() {
    _currentItem = items.first;
    _indexOfCurrentItem = 0;
  }

  // ...........................................................................
  void jumpToOrBefore(Seconds timePosition) {
    if (timePosition >= _currentItem.validFrom &&
        timePosition < _currentItem.validTo) {
      return;
    }

    final startIndex = _indexOfCurrentItem;

    // Find or item in future
    var index = startIndex;
    if (timePosition > _currentItem.validFrom) {
      while (++index < items.length) {
        final snapShot = items[index];
        if (snapShot.validFrom > timePosition) {
          break;
        }
        _indexOfCurrentItem = index;
        _currentItem = snapShot;
      }
    }

    // Find item in past
    else {
      while (--index >= 0) {
        final snapShot = items[index];
        _indexOfCurrentItem = index;
        _currentItem = snapShot;

        if (snapShot.validFrom <= timePosition) {
          break;
        }
      }
    }
  }

  // ...........................................................................
  /// Returns the current item
  GgTimelineItem<T> get currentItem => _currentItem;

  // ...........................................................................
  /// Returns the next item.
  /// Returns the last item when no following item is available
  GgTimelineItem<T> get nextItem => _indexOfCurrentItem == _timeline.length - 1
      ? _currentItem
      : _timeline[_indexOfCurrentItem + 1];

  // ...........................................................................
  bool tryToReplaceLastItem({
    required T data,
    required Seconds timePosition,
  }) {
    if (timePosition == _currentItem.validFrom) {
      _currentItem = createItem(
        data: data,
        timePosition: timePosition,
      );

      _timeline[_indexOfCurrentItem] = _currentItem;
      return true;
    }

    return false;
  }

  // ...........................................................................
  void addOrReplaceItem({
    required T data,
    required Seconds validFrom,
  }) {
    jumpToOrBefore(validFrom);

    // Just replace last item when possible
    if (tryToReplaceLastItem(
      data: data,
      timePosition: validFrom,
    )) {
      return;
    }

    // Update validTo at previousItem
    _timeline[_indexOfCurrentItem] = _currentItem.copyWith(validTo: validFrom);

    // Insert a new item
    final newItem = createItem(
      data: data,
      timePosition: validFrom,
    );

    _timeline.insert(_indexOfCurrentItem + 1, newItem);
  }

  // ...........................................................................
  GgTimelineItem<T> createItem({
    required T data,
    required Seconds timePosition,
  }) =>
      GgTimelineItem<T>(
        validFrom: timePosition,
        validTo: timePosition,
        data: data,
      );

  // ######################
  // Private
  // ######################

  // ...........................................................................
  final _timeline = <GgTimelineItem<T>>[];
  var _indexOfCurrentItem = 0;
  late GgTimelineItem<T> _currentItem;

  // ...........................................................................
  void _init() {
    _initInitialItem();
  }

  // ...........................................................................
  void _initInitialItem() {
    _currentItem = createItem(
      data: seed,
      timePosition: 0.0,
    );

    _indexOfCurrentItem = 0;
    _timeline.add(_currentItem);
  }
}

// #############################################################################
class ExampleTimeline extends GgTimeline<int> {
  ExampleTimeline() {
    _addFurtherItems();
  }

  // ...........................................................................
  @override
  int get seed => 0;

  static const int numItems = 20;

  // ...........................................................................
  void _addFurtherItems() {
    for (int i = 0; i < numItems; i++) {
      addOrReplaceItem(
        data: i,
        validFrom: i.toDouble(),
      );
    }
  }
}

final exampleGgTimeline = ExampleTimeline();

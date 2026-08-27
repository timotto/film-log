List<int> generatePossibleFrameNumberEditValues({
  required int filmInstanceMaxPhotoCount,
  required int currentPhotoFrameNumber,
  required List<int> existingPhotoFrameNumbers,
  double extraFilmCapacity = 0.2,
}) {
  if (filmInstanceMaxPhotoCount == 0) {
    filmInstanceMaxPhotoCount = 36;
  }

  var capacityAdd = (extraFilmCapacity * filmInstanceMaxPhotoCount);
  var n = ((filmInstanceMaxPhotoCount > currentPhotoFrameNumber ? filmInstanceMaxPhotoCount : currentPhotoFrameNumber) + capacityAdd).toInt();
  var firstUnusedFrameBefore = -1;
  for (var i = currentPhotoFrameNumber - 1; i > 0; i--) {
    if (existingPhotoFrameNumbers.contains(i)) {
      break;
    }
    firstUnusedFrameBefore = i;
  }
  var spaceBefore = firstUnusedFrameBefore != -1
      ? currentPhotoFrameNumber - firstUnusedFrameBefore
      : 0;

  var blockLength = 1;
  for (var i = currentPhotoFrameNumber + 1; i <= n; i++) {
    if (!existingPhotoFrameNumbers.contains(i)) {
      break;
    }
    blockLength++;
  }

  var firstUsedAfterBlock = -1;
  for (var i = currentPhotoFrameNumber + blockLength; i <= n; i++) {
    if (existingPhotoFrameNumbers.contains(i)) {
      firstUsedAfterBlock = i;
      break;
    }
  }
  var spaceAfter = ((firstUsedAfterBlock == -1 ? n : firstUsedAfterBlock) -
      currentPhotoFrameNumber -
      blockLength);

  List<int> res = [];
  for(var i = currentPhotoFrameNumber - spaceBefore; i <= currentPhotoFrameNumber + spaceAfter; i++) {
    res.add(i);
  }

  res.sort();

  return res;
}

final class FrameNumberEdits {
  const FrameNumberEdits(
    this.edits, {
    this.conflict = false,
  });

  final bool conflict;
  final Iterable<MapEntry<int, int>> edits;

  static entry(int from, int to) => MapEntry<int, int>(from, to);
}

/// Generates the "other edits" when updating a photo's frame number value.
FrameNumberEdits generateFrameNumberEdits({
  required List<int> existingFrameNumbers,
  required int previousFrameNumberValue,
  required int updatedFrameNumberValue,
}) {
  if (previousFrameNumberValue == updatedFrameNumberValue) {
    return FrameNumberEdits([]);
  }

  if (existingFrameNumbers.isEmpty) {
    return FrameNumberEdits([]);
  }

  if (!existingFrameNumbers.contains(previousFrameNumberValue)) {
    return FrameNumberEdits([]);
  }

  existingFrameNumbers.sort();
  var indexPrev = existingFrameNumbers.indexOf(previousFrameNumberValue);
  var indexUpdated = existingFrameNumbers.indexOf(updatedFrameNumberValue);
  if (indexPrev == -1) {
    return FrameNumberEdits([]);
  }

  var delta = updatedFrameNumberValue - previousFrameNumberValue;
  if (delta == 0) {
    return FrameNumberEdits([]);
  }

  Iterable<MapEntry<int,int>> edits;

  if (delta < 0) {
    // cannot overwrite existing items
    if (indexUpdated != -1) {
      print(
          'frame shift conflict: delta=[$delta] indexPrev=[$indexPrev] indexUpdated=[$indexUpdated]');
      return FrameNumberEdits([], conflict: true);
    }

    for (var i = updatedFrameNumberValue; i < previousFrameNumberValue; i++) {
      if (existingFrameNumbers.contains(i)) {
        print(
            'frame shift conflict: delta=[$delta] indexPrev=[$indexPrev] indexUpdated=[$indexUpdated] exists=[$i]');
        return FrameNumberEdits([], conflict: true);
      }
    }

    edits = existingFrameNumbers
        .skip(1 + indexPrev)
        .map((frameNumber) => MapEntry(frameNumber, frameNumber + delta));
  } else {
    List<MapEntry<int,int>> items = [];

    var rest = existingFrameNumbers.skip(indexPrev).toList();
    for(var i=1;i<rest.length;i++) {
      var val = rest[i];
      var before = rest[i-1];
      if (val != (before+1)) break;
      items.add(MapEntry(val, val+delta));
    }

    edits = items;
  }

  return FrameNumberEdits(edits);
}

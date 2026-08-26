String suggestNextFilmName({
  required String previousFilmName,
  required String fallbackName,
}) {
  var parts = previousFilmName.split(' ');
  if (parts.isEmpty) return fallbackName;

  var num = int.tryParse(parts.last);
  if (num != null && parts.last == num.toString()) {
    parts[parts.length - 1] = (num + 1).toString();
    return parts.join(' ');
  }

  parts.add('2');

  return parts.join(' ');
}

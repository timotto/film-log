bool sameList<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  final n = a.length;
  for (var i = 0; i < n; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

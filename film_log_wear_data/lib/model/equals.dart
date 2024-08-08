abstract class Equals<T> {
  bool equals(T other);

  static bool all<T extends Equals>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    final n = a.length;
    for (var i = 0; i < n; i++) {
      if (!a[i].equals(b[i])) return false;
    }
    return true;
  }
}

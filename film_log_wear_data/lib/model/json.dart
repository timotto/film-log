List<T> typedList<T>(List<dynamic> items) =>
    items.map<T>((item) => item).toList(growable: false);

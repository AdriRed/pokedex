class HelperMethods {
  static dynamic unwrapList(dynamic list) {
    List<dynamic> allItems = new List();

    if (list is Iterable) {
      for (var item in list) {
        allItems.addAll(unwrapList(item));
      }
      return allItems;
    } else {
      allItems.add(list);
      return allItems;
    }
  }
}
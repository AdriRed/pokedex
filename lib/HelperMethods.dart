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

  static List<List<dynamic>> splitIn(List<dynamic> list, int chunks) {
    if (list.isEmpty) return list;
    List<List<dynamic>> superlist = new List();
    for (var i = 0; i < list.length; i += chunks) {
      superlist.add(list.sublist(i, i + chunks));
    }
    return superlist;
  }
}

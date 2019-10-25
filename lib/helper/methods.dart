class ExtraMethods {

  static dynamic unwrapList(dynamic list) {
    
    if (list is List) {
      List<dynamic> allItems = new List();
      for (var item in list) {
        allItems.add(unwrapList(item));
      }
      return allItems;
    } else {
      return list;
    }
  }

}
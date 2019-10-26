abstract class Provider<T> {
  String uri;
  T info;

  void getInfo();

  Provider(String uri) {
    this.uri = uri;
  }
}

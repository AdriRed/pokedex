import 'dart:async';

class LockManager {

static Locker getLocker() => new Locker();

}

class Locker {

  Future<Null> _isWorking = null;
  Completer<Null> completer;
  Function _function;
  bool get locked => _isWorking != null;

  lock() {
    completer = new Completer();
    _isWorking = completer.future;
  }

  unlock() {
    completer.complete();
    _isWorking = null;
  }

  waitLock() async {
      await _isWorking;
      return _function();
  }

  setFunction(Function fun) {
    if (_function == null) _function = fun;
  }

}
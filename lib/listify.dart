class Model {
  /// Return the value of primary key for the object
  String getKey() {
    return "";
  }
}

class Listify<T extends Model> {
  final List<T> _list = <T>[];
  bool isEmpty() {
    return _list.isEmpty;
  }

  bool _isPresent(String key) {
    return _list.any((element) => element.getKey() == key);
  }

  T? getElement(String key) {
    if (_isPresent(key)) {
      return _list.firstWhere(
        (element) => element.getKey() == key,
      );
    } else {
      return null;
    }
  }

  bool addNew(String key, T newT) {
    if (_isPresent(key)) return false;
    _list.add(newT);
    return true;
  }

  bool remove(String key) {
    if (!_isPresent(key)) return false;
    _list.removeWhere((element) => element.getKey() == key);
    return true;
  }

  List<T> getList() {
    return _list.toList();
  }
}

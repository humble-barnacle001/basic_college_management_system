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

  bool isPresent(String key) {
    return _isPresent(key);
  }

  bool _isPresent(String key) {
    return _list.any((element) => element.getKey() == key);
  }

  int getLength() {
    return _list.length;
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

  T? getElementAtIndex(int index) {
    return (_list.length > index) ? _list.elementAt(index) : null;
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

import 'package:q02_college_management_system/listify.dart';

class Department extends Model {
  final String code;
  String name;

  Department(this.code, this.name);
  void updateName(String newName) {
    name = newName;
  }

  @override
  String getKey() {
    return code;
  }

  @override
  String toString() {
    return "$code, $name";
  }
}

class DepartmentList extends Listify<Department> {}

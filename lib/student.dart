import 'package:q02_college_management_system/listify.dart';

class Student extends Model {
  final String roll;
  String name, deptCode, address;
  int phone;

  Student(this.roll, this.name, this.deptCode, this.phone, this.address);
  void updateName(String newName) {
    name = newName;
  }

  @override
  String getKey() {
    return roll;
  }

  @override
  String toString([String? deptName]) {
    return "Roll: $roll;\nName: $name;\nDepartment ${deptName == null ? "Code" : "Name"}: ${deptName ?? deptCode};\nAddress: $address;\nPhone: $phone";
  }
}

class StudentList extends Listify<Student> {
  bool updateStudent(
      String roll, String name, String deptCode, String address, int phone) {
    Student? s = super.getElement(roll);
    if (s == null) return false;

    s.name = name;
    s.deptCode = deptCode;
    s.address = address;
    s.phone = phone;
    return true;
  }
}

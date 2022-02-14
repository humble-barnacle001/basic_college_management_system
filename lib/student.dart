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
  String toString() {
    return "Roll: $roll,\nName: $name,\nDepartment Code: $deptCode,\nAddress: $address,\nPhone: $phone";
  }
}

class StudentList extends Listify<Student> {}

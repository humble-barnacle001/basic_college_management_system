import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q02_college_management_system/department.dart';
import 'package:q02_college_management_system/listify.dart';
import 'package:q02_college_management_system/student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      home: const MyHomePage(title: 'College Management System'),
    );
  }
}

String? validateAsRequired(dynamic value) {
  return value == null || value == "" ? "Input is required" : null;
}

String? validateAsPhone(dynamic value) {
  return validateAsRequired(value) != null ||
          int.tryParse(value) == null ||
          value.length != 10
      ? "10 digit phone input required"
      : null;
}

String? validateIsPresent(dynamic value, Listify listObject,
    {bool reverse = false}) {
  return validateAsRequired(value) != null ||
          (reverse ^ !listObject.isPresent(value))
      ? "Invalid input: Input ${reverse ? "already present" : "not present"}"
      : null;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _rand = Random();
  final _controllerList =
      List<TextEditingController>.generate(5, (_) => TextEditingController());
  int _index = 0;
  final elementPerPage = 5;
  final _deptList = DepartmentList();
  final _studentList = StudentList();

  String? _deptTextController = "";

  static const _nums = '123456789';
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz' + _nums;
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rand.nextInt(_chars.length))));

  int getRandomNumber(int length) =>
      int.parse(String.fromCharCodes(Iterable.generate(
          length, (_) => _nums.codeUnitAt(_rand.nextInt(_nums.length)))));

  @override
  void initState() {
    super.initState();
    String id = getRandomString(4),
        id2 = getRandomString(4),
        id3 = getRandomString(4);
    _deptList.addNew(id, Department(id, "Computer Science"));
    _deptList.addNew(id2, Department(id2, "Mechanical"));
    _deptList.addNew(id3, Department(id3, "Electronics & Telecommunications"));

    String sid = getRandomNumber(6).toString(),
        sid2 = getRandomNumber(6).toString(),
        sid3 = getRandomNumber(6).toString(),
        sid4 = getRandomNumber(6).toString(),
        sid5 = getRandomNumber(6).toString();
    _studentList.addNew(
        sid,
        Student(
            sid,
            getRandomString(10),
            _deptList
                .getElementAtIndex(_rand.nextInt(_deptList.getLength()))!
                .code,
            getRandomNumber(10),
            "${getRandomString(5)}, ${getRandomString(10)}"));

    _studentList.addNew(
        sid2,
        Student(
            sid2,
            getRandomString(10),
            _deptList
                .getElementAtIndex(_rand.nextInt(_deptList.getLength()))!
                .code,
            getRandomNumber(10),
            "${getRandomString(5)}, ${getRandomString(10)}"));

    _studentList.addNew(
        sid3,
        Student(
            sid3,
            getRandomString(10),
            _deptList
                .getElementAtIndex(_rand.nextInt(_deptList.getLength()))!
                .code,
            getRandomNumber(10),
            "${getRandomString(5)}, ${getRandomString(10)}"));

    _studentList.addNew(
        sid4,
        Student(
            sid4,
            getRandomString(10),
            _deptList
                .getElementAtIndex(_rand.nextInt(_deptList.getLength()))!
                .code,
            getRandomNumber(10),
            "${getRandomString(5)}, ${getRandomString(10)}"));

    _studentList.addNew(
        sid5,
        Student(
            sid5,
            getRandomString(10),
            _deptList
                .getElementAtIndex(_rand.nextInt(_deptList.getLength()))!
                .code,
            getRandomNumber(10),
            "${getRandomString(5)}, ${getRandomString(10)}"));
  }

  @override
  void dispose() {
    for (var element in _controllerList) {
      element.dispose();
    }
    super.dispose();
  }

  void _changeIndex(int a) {
    setState(() {
      _index += a;
    });
  }

  void _searchStudent() {
    String roll = _controllerList[0].value.text;
    final res = _studentList.getElement(roll);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Search result for roll: "$roll"'),
        content: Text(
          res == null
              ? "Not Found!!"
              : res.toString(_deptList.getElement(res.deptCode)!.name),
          style: TextStyle(color: (res == null ? Colors.red : Colors.green)),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _removeStudent(String roll) {
    setState(() {
      bool res = _studentList.remove(roll);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "${res ? "Successfully deleted" : "Could not delete"} student with roll: $roll"),
      ));
    });
  }

  void _addUpdateStudent(
      String roll, String name, String deptCode, String address, int phone,
      [bool isUpdate = false]) {
    setState(() {
      bool res = (isUpdate)
          ? _studentList.updateStudent(
              _controllerList[1].text,
              _controllerList[2].text,
              _deptTextController!,
              _controllerList[3].text,
              int.parse(_controllerList[4].text))
          : _studentList.addNew(
              _controllerList[1].text,
              Student(
                  _controllerList[1].text,
                  _controllerList[2].text,
                  _deptTextController!,
                  int.parse(_controllerList[4].text),
                  _controllerList[3].text));
      String resText1 = isUpdate ? "updated" : "added";
      String resText2 = isUpdate ? "update" : "add";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "${res ? "Successfully $resText1" : "Could not $resText2"} student with roll: $roll"),
      ));
    });
  }

  void _resetForm() {
    for (var element in _controllerList) {
      element.clear();
    }
    _deptTextController = null;
  }

  void _addStudentForm({bool isUpdate = false}) {
    if (!isUpdate) _resetForm();
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                            enabled: !isUpdate,
                            validator: (value) => validateIsPresent(
                                value, _studentList,
                                reverse: !isUpdate && true),
                            controller: _controllerList[1],
                            decoration: const InputDecoration(
                              labelText: "Roll Number",
                            )),
                        TextFormField(
                            validator: validateAsRequired,
                            controller: _controllerList[2],
                            decoration: const InputDecoration(
                              labelText: "Name",
                            )),
                        DropdownButtonFormField(
                            decoration:
                                const InputDecoration(labelText: "Department"),
                            value: _deptTextController,
                            validator: (value) =>
                                validateIsPresent(value, _deptList),
                            items: _deptList
                                .getList()
                                .map<DropdownMenuItem<String>>((e) =>
                                    DropdownMenuItem(
                                        value: e.code, child: Text(e.name)))
                                .toList(),
                            onChanged: (String? x) {
                              setState(() {
                                _deptTextController = x!;
                              });
                            }),
                        TextFormField(
                            validator: validateAsRequired,
                            controller: _controllerList[3],
                            decoration: const InputDecoration(
                              labelText: "Address",
                            )),
                        TextFormField(
                            validator: validateAsPhone,
                            controller: _controllerList[4],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Phone",
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              _addUpdateStudent(
                                  _controllerList[1].text,
                                  _controllerList[2].text,
                                  _deptTextController!,
                                  _controllerList[3].text,
                                  int.parse(_controllerList[4].text),
                                  isUpdate);
                              _resetForm();
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    )))));
  }

  Widget _buildTable() {
    return DataTable(
        border: TableBorder.all(),
        headingRowColor: MaterialStateProperty.resolveWith<Color?>(
            (_) => Theme.of(context).colorScheme.background.withOpacity(0.28)),
        columns: const [
          DataColumn(label: Text("Roll Number")),
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Department Name")),
          DataColumn(label: Text("Address & Phone")),
          DataColumn(label: Text("Edit")),
          DataColumn(label: Text("Delete")),
        ],
        rows: _studentList
            .getList()
            .getRange(_index * elementPerPage,
                min(_studentList.getLength(), (_index + 1) * elementPerPage))
            .map(
              (s) => DataRow(cells: [
                DataCell(Text(s.roll)),
                DataCell(Text(s.name)),
                DataCell(Text(_deptList.getElement(s.deptCode)!.name)),
                DataCell(Text("${s.address}\nPhone: ${s.phone}")),
                DataCell(IconButton(
                  splashRadius: 16,
                  color: Colors.amber,
                  splashColor: Colors.amber.shade200,
                  onPressed: () {
                    _controllerList[1].text = s.roll;
                    _controllerList[2].text = s.name;
                    _deptTextController = s.deptCode;
                    _controllerList[3].text = s.address;
                    _controllerList[4].text = s.phone.toString();

                    _addStudentForm(isUpdate: true);
                  },
                  tooltip: "Edit Student",
                  icon: const Icon(Icons.edit_outlined),
                )),
                DataCell(IconButton(
                  splashRadius: 16,
                  color: Colors.red,
                  splashColor: Colors.red.shade200,
                  onPressed: () => _removeStudent(s.roll),
                  tooltip: "Remove Student",
                  icon: const Icon(Icons.delete_outlined),
                ))
              ]),
            )
            .toList());
  }

  Widget _buildTableFooter() {
    return (_studentList.isEmpty())
        ? const Text(
            "No records to show!!",
            style: TextStyle(fontSize: 20, color: Colors.red),
            textAlign: TextAlign.center,
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: _index == 0 ? null : () => _changeIndex(-1),
                    child: RichText(
                        text: const TextSpan(children: [
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(Icons.chevron_left)),
                      TextSpan(
                          text: " Previous", style: TextStyle(color: Colors.white))
                    ]))),
                ElevatedButton(
                    onPressed: _index ==
                            (_studentList.getLength() - 1) ~/ elementPerPage
                        ? null
                        : () => _changeIndex(1),
                    child: RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                          text: "Next ", style: TextStyle(color: Colors.white)),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(Icons.chevron_right))
                    ]))),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: [
        const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Students List",
              style: TextStyle(fontSize: 50),
              textAlign: TextAlign.center,
            )),
        Container(
            margin: const EdgeInsets.all(32.0),
            child: TextFormField(
                controller: _controllerList[0],
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffix: ElevatedButton(
                        onPressed: _searchStudent, child: const Text("Submit")),
                    labelText: "Search by student's roll"),
                onEditingComplete: _searchStudent)),
        Center(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, child: _buildTable()))),
        _buildTableFooter(),
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: _addStudentForm,
          tooltip: 'Add Student',
          child: const Icon(Icons.person_add_alt_1)),
    );
  }
}

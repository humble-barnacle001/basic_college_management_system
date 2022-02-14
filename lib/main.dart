import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:q02_college_management_system/department.dart';
import 'package:q02_college_management_system/student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: 'College Management System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _rand = Random();
  final TextEditingController _searchController = TextEditingController();
  final _deptList = DepartmentList();
  final _studentList = StudentList();

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890 -';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rand.nextInt(_chars.length))));

  @override
  void initState() {
    super.initState();
    String id = getRandomString(4), id2 = getRandomString(4);
    _deptList.addNew(id, Department(id, getRandomString(10)));
    _deptList.addNew(id2, Department(id2, getRandomString(10)));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchStudent(String roll) {
    final res = _studentList.getElement(roll);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Search result for roll: $roll'),
        content: Text(
          res == null ? "Not Found!!" : res.toString(),
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
      _studentList.remove(roll);
    });
  }

  void _addStudent() {
    setState(() {
      if (_rand.nextBool()) {
        String id = getRandomString(4);
        _deptList.addNew(id, Department(id, getRandomString(10)));
      }
      String id = getRandomString(4);
      _studentList.addNew(
          id,
          Student(
              id,
              "Test",
              _deptList
                  .getList()
                  .elementAt(_rand.nextInt(_deptList.getList().length))
                  .getKey(),
              _rand.nextInt(10000000),
              "Test Address, ${getRandomString(5)}, ${getRandomString(10)}"));
      if (kDebugMode) {
        print(_deptList.getList());
      }
    });
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
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffix: ElevatedButton(
                        onPressed: () =>
                            _searchStudent(_searchController.value.text),
                        child: const Text("Submit")),
                    labelText: "Search by student's roll"),
                onSubmitted: _searchStudent)),
        Center(
            child: Container(
                margin: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        border: TableBorder.all(),
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
                            .map(
                              (s) => DataRow(cells: [
                                DataCell(Text(s.roll)),
                                DataCell(Text(s.name)),
                                DataCell(Text(
                                    _deptList.getElement(s.deptCode)!.name)),
                                DataCell(
                                    Text("${s.address}\nPhone: ${s.phone}")),
                                DataCell(IconButton(
                                  splashRadius: 16,
                                  color: Colors.amber,
                                  splashColor: Colors.amber.shade200,
                                  onPressed: () {},
                                  tooltip: "Not activated yet!",
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
                            .toList())))),
        if (_studentList.isEmpty())
          const Text(
            "No records to show!!",
            style: TextStyle(fontSize: 20, color: Colors.red),
            textAlign: TextAlign.center,
          )
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade900,
        onPressed: _addStudent,
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

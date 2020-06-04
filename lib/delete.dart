import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'insert.dart';
import 'update.dart';
import 'delete.dart';
import 'select.dart';
import 'students.dart';
import 'dart:async';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.lightGreen),
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.lightGreen),
      home: Search(),
    );
  }
}

class Delete extends StatefulWidget {
  @override
  _myDelete createState() => new _myDelete();
}

class _myDelete extends State<Delete> {
  // VAR MANEJO BD
  Future<List<Student>> Students;
  TextEditingController controllerN = TextEditingController();
  TextEditingController controllerAP = TextEditingController();
  TextEditingController controllerAPP = TextEditingController();
  TextEditingController controllerTE = TextEditingController();
  TextEditingController controllerC = TextEditingController();
  TextEditingController controllerM = TextEditingController();

  int currentUserId;
  String name;
  String app;
  String appP;
  String telef;
  String correo;
  String matricula;

  final formkey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var dbHelper;
  bool isUpdating;


  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Students = dbHelper.getStudents();
    });
  }

  void cleanData() {
    controllerM.text = "";
    controllerAPP.text = "";
    controllerAP.text = "";
    controllerTE.text = "";
    controllerC.text = "";
    controllerN.text = "";
  }

  void dataValidate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name, app, appP, telef, correo, matricula);
        dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name, app, appP, telef, correo, matricula);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }

  // SHOW DATA
  SingleChildScrollView dataTable(List<Student> Students) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Delete."),
          ),
          DataColumn(
            label: Text("Nombre."),
          ),
          DataColumn(
            label: Text("Apellido Materno."),
          ),
          DataColumn(
            label: Text("Apellido Paterno."),
          ),
          DataColumn(
            label: Text("Telefono."),
          ),
          DataColumn(
            label: Text("Correo."),
          ),
          DataColumn(
            label: Text("Matricula."),
          ),
        ],
        rows: Students.map((student) => DataRow(cells: [
          DataCell(
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.white,
              onPressed: () {
                dbHelper.delete(student.controlnum);
                final snackBar=SnackBar(
                  backgroundColor: Colors.orangeAccent,
                  content: Text('Eliminado'),
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
                refreshList();
              },
            ),
          ),

          DataCell(Text(student.name.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controllerN.text = student.name;
          }),
          DataCell(Text(student.app.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controllerAP.text = student.app;
          }),

          DataCell(Text(student.appP.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controllerAPP.text = student.appP;
          }),

          DataCell(Text(student.telef.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controllerTE.text = student.telef;
          }),

          DataCell(Text(student.correo.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controllerC.text = student.correo;
          }),

          DataCell(Text(student.matricula.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true;
              currentUserId = student.controlnum;
            });
            controllerM.text = student.matricula;
          }),

        ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Students,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("No data founded!");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key:_scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Bienvenido',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage("https://i.pinimg.com/564x/c6/ba/ed/c6baed10c25ed570e5fa47cf709796d8.jpg"),
                ),
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.tealAccent,),
              title: Text('Insert'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Insert()));
              },
            ),
            ListTile(
              title: Text('Update'),
              leading: Icon(Icons.update, color: Colors.tealAccent,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Update()));
              },
            ),
            ListTile(
              title: Text('Delete'),
              leading: Icon(Icons.delete, color: Colors.tealAccent,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Delete()));
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: Colors.tealAccent,),
              title: Text('Select'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Search()));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: Text('Delete'),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:test_1/pages/history.dart';
//import 'package:test_1/pages/root_page.dart';
//import 'package:test_1/service/authentication.dart';
import 'package:test_1/test2/authentication.dart';
import 'package:test_1/pages/scan.dart';
import 'package:test_1/test2/d_page.dart';

//import 'package:test_1/test2/d_page.dart';
import 'service/payment.dart';
import 'test2/login_signup_page.dart';
import 'package:test_1/pages/root_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      //home:  RootPage(auth:  Auth()),
      //home:  MyHomePage(),
      //home: PaymentPage(),
      //home: ScanScreen(),
       // home: new RootPage(auth: Auth()),
      home: DPage(auth: Auth(),),
      //home: HistoryPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ListTileModel {

  String text;

  ListTileModel(this.text);
}

class _MyHomePageState extends State<MyHomePage> {
  String input;

  bool rememberMe = false;

  List<ListTileModel> _items = [];


  void _add() {
    _items.add(ListTileModel(input));
    setState(() {});
  }

  final databaseReference = FirebaseDatabase.instance.reference();
  final db = FirebaseDatabase.instance.reference().child("test_users");

  int count=5;


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('                    FlutterFire Test'),
      ),
      body: ListView(
          padding: EdgeInsets.all(28.0),
           children: <Widget>[

              /*
              RaisedButton(
                child: Text('Create Record'),
                onPressed: () {
                  createRecord();
                },
              ),

              RaisedButton(
                child: Text('View Record'),
                onPressed: () {
                  getData();
                },
              ),
              RaisedButton(
                child: Text('Udate Record'),
                onPressed: () {
                  updateData();
                },
              ),
              RaisedButton(
                child: Text('Delete Record'),
                onPressed: () {
                  deleteData();
                },
              ),
             */
             new Row(
               children: <Widget>[
                 SizedBox(width:0.2),
                 new Container(
                   width:200,
                   child: new TextField(
                       textAlign: TextAlign.left,
                       decoration: InputDecoration(
                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(138.0)),
                         hintText: 'Enter the name',
                         // border: InputBorder.none,
                         hintStyle: TextStyle(color: Colors.grey),
                       ),
                       onChanged: (val) {
                         input = val;
                         print(input);
                       }
                   ),
                 ),

                 SizedBox(width:10),
                 new Container(
                   width: 80,
                   child:new Material(
                     borderRadius: BorderRadius.circular(30.5),
                     shadowColor: Colors.lightBlueAccent.shade100,
                     elevation: 1.0,
                     child: new MaterialButton(
                       onPressed: () {
                         createRecord(input);
                         _add();
                       },
                       shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                       child: Text('ADD', style: TextStyle(color: Colors.lightGreen,fontSize: 15)),
                     ),
                   ),
                 ),
               ],
             ),

             SizedBox(height: 30,),
             /*
             new Container(
               width: 120,
               child:new Material(
                 borderRadius: BorderRadius.circular(70.20),
                 shadowColor: Colors.lightBlueAccent.shade100,
                 elevation: 1.0,
                 child: new MaterialButton(
                   onLongPress: () {
                     getData();
                   },
                   shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                   child: Text('View', style: TextStyle(color: Colors.black,fontSize: 20)),
                 ),
               ),
             ),

              */
             SizedBox(height: 30),

             new Container(
               height: 390,
               child: ListView(
                   children: _items
                       .map((item) =>
                        new Text(item.text,style: TextStyle(color: Colors.black,fontSize: 22),
                            textAlign: TextAlign.justify,

                   ),


                   ).toList()
               ),
             ),

            ],

      ), //center
    );
  }

  void createRecord(String ip){
   /* count++;
    db.child(count.toString()).set({
      'name': ip,
    });
    */

    db.push().set({
      'name': ip,
    });

  }
  void getData(){
    //String _value = "10109872120";
    db.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        print(values["name"]);
        //_add(values["name"]);
      });
    });



  }

  /*
  void updateData(){
    databaseReference.child('1').update({
      'description': 'J2EE complete Reference'
    });
  }

   */
/*
  void deleteData(){
    databaseReference.child('2').remove();
  }


 */
}

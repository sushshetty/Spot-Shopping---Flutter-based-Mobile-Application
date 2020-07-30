import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_1/pages/history.dart';
import 'package:test_1/pages/scan.dart';
import 'package:test_1/service/payment.dart';
import 'package:test_1/test2/authentication.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
//import 'package:simple_slider/simple_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AgentHome extends StatefulWidget {

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  const AgentHome({Key key, this.auth, this.logoutCallback, this.userId}) : super(key: key);

  @override
  _AgentHomeState createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {

 var ref = FirebaseDatabase.instance.reference().child("products");





  final TextEditingController _resetPasswordEmailFilter =  new TextEditingController();
  String _resetPasswordEmail = "";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();




  _HomePageState() {
    _resetPasswordEmailFilter.addListener(_resetPasswordEmailListen);
  }

  void _resetPasswordEmailListen() {
    if (_resetPasswordEmailFilter.text.isEmpty) {
      _resetPasswordEmail = "";
    } else {
      _resetPasswordEmail = _resetPasswordEmailFilter.text;
    }
  }





  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;



  bool _isEmailVerified = true;



  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();

  }







  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }


  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
      abc();
    } catch (e) {
      print(e);
    }
  }

  void abc(){
    Fluttertoast.showToast(
        msg: 'Logged out',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 10,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Home Page')

      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Spot Shop',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/drawer.jpg')
                  )
              ),
            ),


            SizedBox(height: 400,),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      body: Container(

        child: ListView(
          children: <Widget>[

            SizedBox(height: 50,),
            _welcome(),
            SizedBox(height: 40,),

            //SizedBox(height: ,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.0,vertical: 30.0),
              child :RaisedButton(
                autofocus: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
                splashColor: Colors.lightBlue,
                color: Colors.orange,
                onPressed: (){

                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ScanScreen()));

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Start Shopping"),
                  ],
                ),
              ),
            ),










          ],
        ),
      ),
    );
  }

  Widget _welcome() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.0,vertical: 0.0),
      child: Text('Welcome to Spot Shop: \n An easy way to skip the queue\n\n Scan the products -> Pay online -> Get Invoice -> Self Checkout',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black87,fontSize: 18,fontStyle: FontStyle.normal),
      ),
    );
  }


  StreamBuilder(){}



}

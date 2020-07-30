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

final List<String> imgList = [
  'https://images.pexels.com/photos/1005638/pexels-photo-1005638.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://media.istockphoto.com/vectors/grocery-supermarket-checkout-line-cartoon-people-standing-in-queue-vector-id1192464212',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRz5Uu33fS986x6cfg4WYSUIvIdMYRrdDLLtYKTwdVjwjXn36Sy',
  'https://news.feinberg.northwestern.edu/wp-content/uploads/sites/15/2018/06/1-Scanning-barcode-using-app-salad.jpg',
  'https://previews.123rf.com/images/artinspiring/artinspiring1608/artinspiring160800529/63286565-mobile-payment-concept-easy-transaction-with-mobile-banking-credit-card-in-tablet-payment-through-in.jpg',
  'https://media.istockphoto.com/vectors/color-background-scene-of-businessman-coming-out-of-store-with-cart-vector-id851887542'
];


final Widget placeholder = Container(color: Colors.grey);

final List child = map<Widget>(
  imgList,
      (index, i) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          Image.network(i, fit: BoxFit.cover, width: 1000.0),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: null,
            ),
          ),
        ]),
      ),
    );
  },
).toList();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}



class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;




  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;






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



  bool _isEmailVerified = false;



  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
          new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resend link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
               'Spot Shop\n Welcome',
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

           ListTile(
             leading: Icon(Icons.history),
             title: Text('History'),
             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HistoryPage())),
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
       decoration: BoxDecoration(
         image: DecorationImage(
           image: AssetImage("assets/background.jpg"),
           fit: BoxFit.cover,
         ),
       ),
      child: ListView(
        children: <Widget>[

          SizedBox(height: 50,),
          _welcome(),
          SizedBox(height: 40,),
          _imageSlider(),
          //SizedBox(height: ,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.0,vertical: 30.0),
          child :RaisedButton(
            autofocus: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
            splashColor: Colors.lightBlue,
            color: Colors.orange,
            onPressed: (){
              if(_isEmailVerified){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ScanScreen()));
              } else {
                _showVerifyEmailDialog();
                _signOut();
              }
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

  final CarouselSlider autoPlayDemo = CarouselSlider(
    viewportFraction: 0.9,
    aspectRatio: 2.0,
    autoPlay: true,
    enlargeCenterPage: true,
    items: imgList.map(
          (url) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: 1000.0,
            ),
          ),
        );
      },
    ).toList(),
  );

  Widget _imageSlider(){
    return Column(children: [
      CarouselSlider(
        items: child,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          imgList,
              (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4)),
            );
          },
        ),
      ),
    ]);
  }
}

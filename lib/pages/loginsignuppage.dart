import 'package:flutter/material.dart';


import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:test_1/pages/loginsignuppage.dart';
import 'package:test_1/test2/authentication.dart';

class LogSig extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;

  const LogSig({Key key, this.auth, this.loginCallback}) : super(key: key);

  @override
  _LogSigState createState() => _LogSigState();
}

class _LogSigState extends State<LogSig> {

  final _formKey = new GlobalKey<FormState>();
bool _isLoading=false;
bool _isLoginForm=true;
String _email;
String _password;
String _errorMessage;

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
    ),

    body: Stack(  // using stack as body to overlay one widget above other
      children: <Widget>[
        showForm(), // to use list view to have array of widgets
        showCircularProgress(), // to show loading
      ],
    ),
  );
}

//Building showCircularProgress widget
Widget showCircularProgress(){
  if(_isLoading){
    return Center(child: CircularProgressIndicator());
  }
  //just adding an return statement
  return Container(
    height: 0.0,
    width: 0.0,
  );
}



//Building showForm widget
Widget showForm() {

  return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            showPrimaryButton(),

            showErrorMessage(),
          ],
        ),
      )
  );
}

//building widget to display logo
Widget showLogo(){
  return Hero(
      tag: 'ShopSpot',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),  //padding from all 4 sides
        child:CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/cart.jpg'),
        ) ,
      )
  );
}

//building widget for email text field
Widget showEmailInput(){
  return Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
    child: TextFormField(
      maxLines: 1, //to fix height of text field
      keyboardType: TextInputType.emailAddress,  // keyboard type
      autofocus: false, // prevents field getting focused when page is loaded
      //Decoration used to make UI of text field better
      decoration:  InputDecoration(
        hintText: 'Enter Agent ID',
        icon: Icon(
          Icons.perm_identity,
          color: Colors.greenAccent,
        ),
      ),
      validator: (value) => value.isEmpty ? 'Email cant be empty' : null,  // validates if field is empty
      onSaved: (value) => _email = value.trim(),  // trim removes any whitespace
    ),
  );
}

//building widget for password field
Widget showPasswordInput() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
    child: new TextFormField(
      maxLines: 1,
      obscureText: true,   // to hide password
      autofocus: false,
      decoration: new InputDecoration(
          hintText: 'Password',
          icon: new Icon(
            Icons.lock_outline,
            color: Colors.greenAccent,
          )
      ),
      validator: (value) => value.isEmpty ? 'Password cant be empty' : null,
      onSaved: (value) => _password = value.trim(),
    ),
  );
}

//Building primary button - Login/SignUp
Widget showPrimaryButton(){
  return Padding(
    padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    child: SizedBox(  // a box of fixed size
      height: 40.0,
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.purpleAccent,
        child: Text(_isLoginForm ? 'Login' : 'Register',
          style: TextStyle(fontSize: 20.0,color: Colors.black),
        ),
        onPressed: validateAndSubmit,
      ),
    ),
  );
}




// creating method to toggle form
void toggleFormMode(){
  resetForm();  // method to clear inputs
  setState(() {
    _isLoginForm = !_isLoginForm;
  });
}
// Check if form is valid before perform login or sign up
bool validateAndSave() {
  final form = _formKey.currentState;
  if (form.validate()) {
    form.save();
    return true;
  }
  return false;
}

//performing login or sign up
void validateAndSubmit() async {
  setState(() {
    _errorMessage = "";
    _isLoading = true;
  });
  if (validateAndSave()) {
    String userId = "";
    try {
      if (_isLoginForm) {
        userId = await widget.auth.signIn(_email, _password);
        abc();
        print('Signed in: $userId');
      } else {
        userId = await widget.auth.signUp(_email, _password);
        print('Signed up user: $userId');
        xyz();
      }
      setState(() {
        _isLoading = false;
      });


    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
        _formKey.currentState.reset();
      });
    }
  }
}

void abc(){
  Fluttertoast.showToast(
      msg: 'Login successful',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 10,
      backgroundColor: Colors.green,
      textColor: Colors.black,
      fontSize: 16.0
  );
}

void xyz(){
  Fluttertoast.showToast(
      msg: 'Registered sucessfully\n Please log in to continue',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 20,
      backgroundColor: Colors.green,
      textColor: Colors.black,
      fontSize: 16.0);

}

@override
void initState() {
  _errorMessage = "";
  _isLoading = false;
  _isLoginForm = true;
  super.initState();
}

void resetForm() {
  _formKey.currentState.reset();
  _errorMessage = "";
}



//widget to display error messages
Widget showErrorMessage() {
  if (/*_errorMessage.length > 0 &&*/  _errorMessage != null) {
    return new Text(
      _errorMessage,
      style: TextStyle(
          fontSize: 13.0,
          color: Colors.redAccent,
          height: 1.0,
          fontWeight: FontWeight.w300
      ),
    );
  } else {
    return new Container(
      height: 0.0,
    );
  }
}
}

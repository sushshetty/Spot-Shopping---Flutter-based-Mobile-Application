import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:test_1/pages/invoice.dart';
import 'package:test_1/service/payment.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class ListTileModel {
  String text;
  bool comparison;
  String barcode;

  ListTileModel(this.text,this.comparison,this.barcode);
}

class _ScanScreenState extends State<ScanScreen> {
  bool payment = true;
  var paymentId;
  Razorpay _razorpay;

  final databaseReference = FirebaseDatabase.instance.reference();
  final db = FirebaseDatabase.instance.reference().child("History");
  var prod = FirebaseDatabase.instance.reference().child("products");

  var path = FirebaseDatabase.instance.reference().child("prd");

  List<ListTileModel> _items = [];

  get System => null;

  void _add() {

    databaseReference.child("hstry").child(count.toString()).set({
      'Name': aaa,
      'Price': price.toString()
    });

    databaseReference.child("total").child("det").set({
      'bill': bill,

    });

    if(price <= bill2 || price <= bill3){
      comparison = true;
      text = "Best price";
    } else if(price > bill2 || price <= bill3){
      comparison =false;
      text = "SPAR has the product for better price";
    }else if (price >bill3 || price <= bill2){
      comparison =false;
      text = m2+"SPAR has the product for better price";
    }else {
      comparison =false;
      text = m1+"and SPAR Has the product foe better price";
    }




    /*if(bill2>=price ){
      comparison = true;
    }else comparison =false;*/

    _items.add(ListTileModel(text,comparison,barcode));
      setState(() {});
      count++;
  }



  String barcode = "";
  String text="";
  String name = "";
  String m1="";
  String m2="";
  int bill = 0;
  int bill2=0;
  int bill3=0;
  int price = 0;
  String aaa ="";
  int count =1;
  bool comparison =false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
       // width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(28.0),
        child: ListView(

          children: <Widget>[
            Divider(thickness: 1.0,color: Colors.black87),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //SizedBox(width: 10,),

                Text('Product',textAlign: TextAlign.center,style: TextStyle(color: Colors.black87,fontSize: 20,),),
                SizedBox(width: 160,),
                VerticalDivider(thickness: 1.0,),
                Text('Price',textAlign: TextAlign.center,style: TextStyle(color: Colors.black87,fontSize: 20,),),
                //SizedBox(width: 30,)
              ],
            ),
            Divider(thickness: 1.0,color: Colors.black87),
            SizedBox(height: 20,),
            SizedBox(height: 30,),
            new Container(
              height: 390,
              child: ListView(
                scrollDirection: Axis.vertical,
                  children: _items
                      .map((item) => StreamBuilder(
                  stream: FirebaseDatabase.instance.reference().child('prd').child(item.barcode).onValue,

                  builder: (context, snap) {
                    print(item.barcode);
                    if(snap.hasData){
                      DataSnapshot snapshot = snap.data.snapshot;
                      Map<dynamic, dynamic> itm = snapshot.value;
                      return snap.data.snapshot.value == null
                          ? SizedBox()
                          : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(height: 40,),
                              SizedBox(height: 15,width: 10,),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 150,minWidth: 150,),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.00001),
                                    borderRadius: BorderRadius.all(Radius.elliptical(19.0,189.0)),
                                    color: Colors.grey[200],
                                    //backgroundBlendMode: BlendMode.color
                                  ),
                                  //color : Colors.grey,
                                  child: Text(itm['det']['name'] ,style: TextStyle(fontSize: 15),),
                                ),
                              ),


                              SizedBox(width: 80,),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 150,minWidth: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.00001),
                                    borderRadius: BorderRadius.all(Radius.elliptical(19.0,189.0)),
                                    color: Colors.grey[200],
                                    //backgroundBlendMode: BlendMode.color
                                  ),
                                  //color : Colors.grey,
                                  child: Text(itm['det']['price'].toString()+' Rs',style: TextStyle(fontSize: 18),),
                                ),
                              ),
                              Visibility(
                                visible: item.comparison,
                                replacement: Tooltip(message:item.text ,child: Icon(Icons.arrow_drop_up,color: Colors.redAccent,size: 25.0,)),
                                child: Tooltip(message: item.text,child: Icon(Icons.arrow_drop_down,color: Colors.green,size: 25.0,)),

                              ),
                            ],
                          );
                        },
                      );
                    }
                    else {
                      return   Center(child: CircularProgressIndicator());
                    }
                  }
              ),
                  ).toList()
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: payment,
        child: FloatingActionButton(
            onPressed: scan,
          child: Icon(Icons.add_shopping_cart),
          tooltip: 'Add to cart',
        ),
      ),
      persistentFooterButtons: <Widget>[
        Text('Total Bill amount: '+bill.toString()+' Rs', textAlign: TextAlign.center,style: TextStyle(color: Colors.black87,fontSize: 20,),),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.0,vertical: 10.0),
          child :Visibility(
            visible: payment,
            child: RaisedButton(
              color: Colors.pink,
              onPressed: launchPayment,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Pay and self checkout"),
                ],
              ),
            ),
            replacement: RaisedButton(
              color: Colors.greenAccent,

              //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PaymentPage(bill: bill,))),
              //onPressed: (){ launchPayment();            },
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => InvoicePage(paymentId:paymentId))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("view invoice"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future scan() async{
    double startTime = System.nanoTime();
    try{
      String barcode = await BarcodeScanner.scan();
      int bil,bil2,bil3;
      String prd;
      setState(() {
          this.barcode = barcode;
        });
      FirebaseDatabase.instance.reference().child('prd').child(barcode).once().then((DataSnapshot snapshot) async {
        Map<dynamic, dynamic> itm = snapshot.value;
        bil = await itm['det']['price'];
        prd = await itm['det']['name'];
        print(bil);

      setState(()  {
          this.bill += bil;
          this.price = bil;
          this.aaa = prd;
        });
      });







      Future.delayed(const Duration(milliseconds: 500), () {
        String market1 = "MORE";
        String market2= "SPAR";
        FirebaseDatabase.instance.reference().child('prd2').child(prd).once().then((DataSnapshot snapshot) async {
          Map<dynamic, dynamic> itm = snapshot.value;
          bil2 = await itm['det']['price'];
          print(bil2);
          setState(()  {
            //this.bill += bil;
            this.bill2 = bil2;
            this.m1=market1;
            //this.aaa = prd;
          });

        });

        FirebaseDatabase.instance.reference().child('prd3').child(prd).once().then((DataSnapshot snapshot) async {
          Map<dynamic, dynamic> itm = snapshot.value;
          bil3 = await itm['det']['price'];
          print(bil3);
          setState(()  {
            //this.bill += bil;
            this.bill3 = bil3;
            this.m2=market2;
            //this.aaa = prd;
          });

        });

        double startTime = System.nanoTime();
        _add();
        double endTime = System.nanoTime();
        print(endTime-startTime);


      });

    }on PlatformException catch(e) {
      if(e.code == BarcodeScanner.CameraAccessDenied){
        setState(() {
          this.barcode = 'Access Denied';
        });
      } else {
        setState(() {
          this.barcode = 'ERROR';
        });
      }
    } on FormatException {
      setState(() {
        this.barcode = 'null';
      });
    } catch (e){
      setState(() {
        this.barcode = 'ERROR';
      });
    } finally{
      //print(barcode);



    }

  }

  void launchPayment() async {
   // double startTime = System.nanoTime();
    var options = {
      'key': 'rzp_test_dcpEg18EO9ge1q',
      'amount': bill * 100,
      'name': 'ShopSpot',
      'description': 'payment from ShopSpot app',
      'prefill': {
        'contact': '',
        'email': ''
      },
      'external': {
        'wallets': []
      }
    };
    try{
      _razorpay.open(options);
    }catch(e){
      debugPrint(e);
    }

  }

  void _handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(
        msg: 'Error '+ response.code.toString() + ' ' + response.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response){
    setState(() {
      payment = false;
      paymentId = response.paymentId.toString();
    });
    Fluttertoast.showToast(
        msg: 'Payment Success '+ response.paymentId,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 20,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(
        msg: 'Wallet Name '+ response.walletName,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0
    );

  }





}

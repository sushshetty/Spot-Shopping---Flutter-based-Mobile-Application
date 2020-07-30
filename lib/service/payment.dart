import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  final int bill;

  const PaymentPage({Key key, this.bill}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int totalAmount = 0;
  Razorpay _razorpay;

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
  void launchPayment() async {
    var options = {
      'key': 'rzp_test_dcpEg18EO9ge1q',
      'amount': totalAmount * 100,
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
    Fluttertoast.showToast(
        msg: 'Payment Success '+ response.paymentId,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 20,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0
    );

    showDialog(
        context: null
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

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        //title: Text("test1"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pay and self checkout',
            ),
            LimitedBox(
              maxWidth: 150.0,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: widget.bill.toString(),

                ),

                onChanged: (val){
                  setState(() {
                    totalAmount = widget.bill;
                  });
                },
              ),
            ),
            SizedBox(
                height: 15.0
            ),
            RaisedButton(
              child: Text('PAY NOW'),
              onPressed: (){
                launchPayment();
              },
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

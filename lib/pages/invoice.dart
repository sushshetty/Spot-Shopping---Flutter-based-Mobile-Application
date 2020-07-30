import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class InvoicePage extends StatefulWidget {
  final String paymentId;

   const InvoicePage({Key key, this.paymentId}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  int total=0;

  @override
  void initState() {
    super.initState();
    getInvoice();
  }

  getInvoice()async{
    int tot=0;
    FirebaseDatabase.instance.reference().child('total').once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> itm = snapshot.value;
      tot = await itm['det']['bill'];
      print(tot);
      setState(()  {
        this.total = tot;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Payment Successful ",style: TextStyle(color: Colors.lightGreen),),
      ),
      body: Container(
        //padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Text("Brindavana super market",style: TextStyle(fontSize: 26),),
            SizedBox(height: 5,),
            Text("Honavar - 581334",style: TextStyle(fontSize: 18),),
            SizedBox(height: 5,),
            Text("GSTIN: 29CODPS2087A2Z",style: TextStyle(fontStyle: FontStyle.italic )),
            SizedBox(height: 5,),
            Text("Payment reference Id :"+widget.paymentId, style: TextStyle(color: Colors.greenAccent),),
            SizedBox(height: 5,),
            Divider(thickness: 1.0,color: Colors.black87),
            //SizedBox(height: 15,),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[

              Text('Product',textAlign: TextAlign.center,style: TextStyle(color: Colors.black87,fontSize: 20,),),
              SizedBox(width: 170,),
              VerticalDivider(thickness: 1.0,),
              Text('Price',textAlign: TextAlign.center,style: TextStyle(color: Colors.black87,fontSize: 20,),),
            ],),
            Divider(thickness: 1.0,color: Colors.black87),
            Expanded(
              child: StreamBuilder(
                stream:FirebaseDatabase.instance.reference().child('hstry').onValue,
                builder: (context,snap){
                  DataSnapshot snapshot = snap.data.snapshot;
                  List item=[];
                  List _list=[];
                  _list=snapshot.value;
                  _list.forEach((f){
                    if(f!=null){
                      item.add(f);
                    }
                  }
                  );
                  return snap.data.snapshot.value == null
                      ? SizedBox()
                      : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: item.length,
                        itemBuilder: (context,index){
                        return Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            SizedBox(height: 40,),
                            SizedBox(height: 15,width: 50,),
                            //SizedBox(width: -20,),
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
                                child: Text(item[index]['Name'],style: TextStyle(fontSize: 18),),
                              ),
                            ),
                            SizedBox(width: 120,),
                            //Text(item[index]['Name'],style: TextStyle(fontSize: 18),),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 50,minWidth: 40,),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.00001),
                                  borderRadius: BorderRadius.all(Radius.elliptical(19.0,189.0)),
                                  color: Colors.grey[200],
                                  //backgroundBlendMode: BlendMode.color
                                ),
                                //color : Colors.grey,
                                child: Text(item[index]['Price'].toString(),style: TextStyle(fontSize: 18),),
                              ),
                            ),

                          ],
                        );
                    }


                  );

                }
              ),
            ),

          ],
        ),

      ),
        persistentFooterButtons: <Widget>[

          Padding(
              padding: EdgeInsets.fromLTRB(0, 1, 10, 0),
              child: Text("Total = "+ total.toString(),style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic),)),

        ],
      floatingActionButton: Transform.scale(
          scale: 2.6,
        child: IconButton(icon: Image.asset('assets/paid.PNG')
            , onPressed: null),
      )
    );
  }
}

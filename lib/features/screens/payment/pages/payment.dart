import 'package:dartfri/features/screens/appointment/models/appointment.dart';
import 'package:dartfri/features/screens/pageImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
   PaymentPage({Key? key, required this.appointment}) : super(key: key);
 final Appointment appointment;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var isSelected = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('Make Payment',style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  // color: Palette.primaryDartfri,

                  borderRadius: BorderRadius.circular(20)
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                     // Text('Choose Payment Method',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Text('Amount :',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                    Text('UGX ${widget.appointment.amount}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),),

                  ],
                ),

                Container(
                       padding: EdgeInsets.all(20),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [

                           GestureDetector(
                             onTap:(){
                               setState(()=>isSelected = 0 );

                                  },
                             child: SizedBox(
                               height: 120,
                               width: MediaQuery.of(context).size.width*0.35,
                               child: Container(
                                 decoration: BoxDecoration(
                                     border: Border.all(color: (isSelected == 0) ? Colors.green : Colors.black,),
                                     borderRadius: BorderRadius.circular(20)

                                 ),
                                 child: Card(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(20)
                                   ),
                                   elevation: 5,
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                     children: [
                                       Icon(Icons.credit_card,size: 50,color: (isSelected == 0) ? Colors.green : Colors.black,),
                                       Text('Card',style: TextStyle(color:(isSelected == 0) ? Colors.green : Colors.black,fontWeight: (isSelected == 0) ? FontWeight.w600 : FontWeight.w400),)
                                     ],
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           GestureDetector(
                             onTap: (){

                                 setState(()=>isSelected = 1 );


                             },
                             child: SizedBox(
                               height: 120,
                               width: MediaQuery.of(context).size.width*0.35,
                               child: Container(
                                 decoration: BoxDecoration(
                                   border: Border.all(color: (isSelected == 1) ? Colors.green : Colors.black),
                                   borderRadius: BorderRadius.circular(20)

                                 ),
                                 child: Card(

                                   shape: RoundedRectangleBorder(

                                     borderRadius: BorderRadius.circular(20)
                                   ),
                                   elevation: 5,
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.spaceAround,

                                     children: [
                                       Icon(Icons.account_balance_wallet_outlined,size: 50,color: (isSelected == 1) ? Colors.green : Colors.black),
                                       Text('Wallet',style: TextStyle(color: (isSelected == 1) ? Colors.green : Colors.black,fontWeight: (isSelected == 1) ? FontWeight.w600 : FontWeight.w400),)
                                     ],
                                   ),
                                 ),
                               ),
                             ),
                           )

                         ],
                       ),
                     ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  // width: MediaQuery.of(context).size.width*0.3,
                  child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        minimumSize: Size.fromHeight(
                            45), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneInput(appointment:appointment)));
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(color: Colors.black),
                      )),
                )
              ],
            ),),
          ),
        ],
      ),
    ));
  }
}

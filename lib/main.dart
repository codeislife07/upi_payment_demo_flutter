import 'package:flutter/material.dart';
import 'package:upi_payment_plugin/model/upi_app_model.dart';
import 'package:upi_payment_plugin/upi_payment_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<UpiAppModel> upiApps = [];
  UpiAppModel? selectedUpiApp;

  // Controllers for text fields
  final TextEditingController payeeUpiIdController = TextEditingController();
  final TextEditingController payeeNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController transactionIdController = TextEditingController();
  final TextEditingController transactionNoteController = TextEditingController();
  
  @override
  void initState() {
    fetchUpiApps();
    super.initState();
  }

  Future<void> fetchUpiApps() async {
    List<UpiAppModel> apps = await UpiPaymentPlugin().getUpiApps();
    setState(() {
      upiApps = apps;
    });
  }

  void initiateUPIPayment() {
    if (selectedUpiApp == null) return;

    String payeeUpiId = payeeUpiIdController.text;
    String payeeName = payeeNameController.text;
    double amount = double.tryParse(amountController.text) ?? 0.0;
    String transactionId = transactionIdController.text;
    String transactionNote = transactionNoteController.text;

    UpiPaymentPlugin.initiateUPIPayment(
      payeeUpiId: payeeUpiId,
      payeeName: payeeName,
      amount: amount,
      transactionId: transactionId,
      transactionNote: transactionNote,
      merchantCode: '1234',
      link: '',
      transactionRefId: 'ref123456',
      packageName: selectedUpiApp?.packageName ?? 'com.google.android.apps.nbu.paisa.user', // default Google Pay
      secretKey: '', // provide by UPI app
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("UPI Payment")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Payment details text fields
              TextField(
                controller: payeeUpiIdController,
                decoration: InputDecoration(labelText: "Enter Payee UPI ID"),
              ),
              TextField(
                controller: payeeNameController,
                decoration: InputDecoration(labelText: "Enter Payee Name"),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter Amount"),
              ),
              TextField(
                controller: transactionIdController,
                decoration: InputDecoration(labelText: "Enter Transaction ID"),
              ),
              TextField(
                controller: transactionNoteController,
                decoration: InputDecoration(labelText: "Enter Transaction Note"),
              ),
              SizedBox(height: 20),
              
              // GridView for UPI apps selection
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: upiApps.length,
                  itemBuilder: (context, index) {
                    UpiAppModel app = upiApps[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedUpiApp = app;
                        });
                      },
                      child: Card(
                        color: selectedUpiApp == app ? Colors.blue : Colors.white,
                        child: Center(
                          child: Text(
                            app.appName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selectedUpiApp == app ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Pay Now Button
              ElevatedButton(
                onPressed: initiateUPIPayment,
                child: Text("Pay Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
